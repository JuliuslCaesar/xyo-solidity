pragma solidity ^0.4.19;

import "ERC20.sol";
import "XYKillable.sol";
import "SafeMath.sol";


contract XYTokenSale is XYKillable {
  using SafeMath
  for * ;

  ERC20 public token; //address of the ERC20 token
  uint private price; //price of tokens (how many tokens per ETH)
  uint public minEther; //minimum amount of Ether required for a purchase (0 for no minimum) 18 places
  address public beneficiary; //where the duplicate tokens go

  event EtherAccepted(address seller, address buyer, uint amount);
  event TokensSent(address seller, address buyer, uint amount);

  constructor(address _token, address _beneficiary, uint _price, uint _minEther) public {
    token = ERC20(_token);
    price = _price;
    minEther = _minEther;
    beneficiary = _beneficiary;
  }

  function () public onlyNotKilled payable {
    purchase();
  }

  function purchase() public onlyNotKilled payable {
    uint ethAmount = msg.value;
    uint tokenAmount = _tokensFromEther(ethAmount);

    require(tokenAmount * 2 <= getAvailableTokens());
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
    token.transferFrom(this, beneficiary, token.balanceOf(this));
    beneficiary.transfer(address(this).balance);
    killed = true;
  }

  function _tokensFromEther(uint _ethAmount) internal onlyNotKilled view returns(uint){
    return SafeMath.div(_ethAmount, 1000000000) * SafeMath.div(getPrice(), 1000000000);
  }

  function _purchase(uint _ethAmount, uint _tokenAmount) internal onlyNotKilled {
    _acceptEther(_ethAmount);
    _sendTokens(_tokenAmount);
  }

  function _acceptEther(uint _amount) internal onlyNotKilled {
    beneficiary.transfer(_amount);
    emit EtherAccepted(beneficiary, msg.sender, _amount);
  }

  function _sendTokens(uint _amount) internal onlyNotKilled {
    if (owner != beneficiary) {
      token.transferFrom(owner, beneficiary, _amount);
    }
    token.transferFrom(owner, msg.sender, _amount);
    emit TokensSent(owner, msg.sender, _amount);
  }

}
