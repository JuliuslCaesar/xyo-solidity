pragma solidity ^0.4.19;

import "./ERC20.sol";
import "./XYKillable.sol";
import "./lib/SafeMath.sol";


contract XYTokenSale is XYKillable {
  using SafeMath
  for * ;

  ERC20 public token; //address of the ERC20 token
  uint private price; //price of tokens (how many tokens per ETH)
  uint public minEther; //minimum amount of Ether required for a purchase (0 for no minimum) 18 places

  event EtherAccepted(address seller, address buyer, uint amount);
  event TokensSent(address seller, address buyer, uint amount);

  function XYTokenSale(address _token, uint _price, uint _minEther) public {
    token = ERC20(_token);
    price = _price;
    minEther = _minEther;
  }

  function () public onlyNotKilled payable {
    purchase();
  }

  function purchase() public onlyNotKilled payable {
    uint ethAmount = msg.value;
    uint tokenAmount = _tokensFromEther(ethAmount);

    require(tokenAmount <= getAvailableTokens());
    require(tokenAmount <= token.balanceOf(owner));
    require(ethAmount >= minEther || minEther == 0);

    _purchase(ethAmount, tokenAmount);
  }

  function getAvailableTokens() public view onlyNotKilled returns(uint) {
    return token.allowance(owner, this);
  }

  function setMinEther(uint _minEther) public onlyOwner onlyNotKilled {
    minEther = _minEther;
  }

  function setPrice(uint _price) public onlyOwner onlyNotKilled {
    price = _price;
  }

  function getPrice() public view onlyNotKilled returns(uint) {
    return price;
  }

  function kill() public onlyOwner {
    token.transferFrom(this, owner, token.balanceOf(this));
    super.kill();
  }

  function _tokensFromEther(uint _ethAmount) internal onlyNotKilled view returns(uint){
    return SafeMath.div(_ethAmount, 1000000000) * SafeMath.div(getPrice(), 1000000000);
  }

  function _purchase(uint _ethAmount, uint _tokenAmount) internal onlyNotKilled {
    _acceptEther(_ethAmount);
    _sendTokens(_tokenAmount);
  }

  function _acceptEther(uint _amount) internal onlyNotKilled {
    owner.transfer(_amount);
    EtherAccepted(owner, msg.sender, _amount);
  }

  function _sendTokens(uint _amount) internal onlyNotKilled {
    token.transferFrom(owner, msg.sender, _amount);
    TokensSent(owner, msg.sender, _amount);
  }

}
