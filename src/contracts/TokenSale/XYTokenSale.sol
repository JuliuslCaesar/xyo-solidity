pragma solidity ^ 0.4 .2;

import "./lib/ERC20.sol";
import "./lib/XYKillable.sol";
import "./lib/SafeMath.sol";


contract XYTokenSale is XYKillable {
  using SafeMath
  for * ;

  // Ownable->owner - address where tokens come from and unused tokens are returned to

  ERC20 public token; //address of the ERC20 token
  address public beneficiary; //address where the ETH payments go to
  uint public price; //price of tokens (how many tokens per ETH)
  uint public minEther; //minimum amount of Ether required for a purchase (0 for no minimum)

  event AcceptEther(address seller, address buyer, uint amount);
  event SendTokens(address seller, address buyer, uint amount);

  function XYTokenSale(address _token, uint _price, uint _minEther) public {
    token = ERC20(_token);
    price = _price;
    minEther = _minEther;
  }

  function() public notKilled payable {
    require(tokenAmount <= getAvailableTokens());
    require(tokenAmount <= token.balanceOf(owner));
    require(ethAmount >= minEther || minEther == 0);

    uint ethAmount = msg.value;
    uint tokenAmount = SafeMath.mul(ethAmount, price);
    _purchase(ethAmount, tokenAmount);
  }

  function getAvailableTokens() public view notKilled returns(uint) {
    return token.allowance(owner, this);
  }

  function setMinEther(uint _minEther) public onlyOwner notKilled {
    minEther = _minEther;
  }

  function setPrice(uint _price) public onlyOwner notKilled {
    price = _price;
  }

  function kill() public onlyOwner {
    token.transferFrom(this, owner, token.balanceOf(this));
    super.kill();
  }

  function _purchase(uint _ethAmount, uint _tokenAmount) internal notKilled {
    _acceptEther(_ethAmount);
    _sendTokens(_tokenAmount);
  }

  function _acceptEther(uint _amount) internal notKilled {
    owner.transfer(_amount);
    AcceptEther(owner, msg.sender, _amount);
  }

  function _sendTokens(uint _amount) internal notKilled {
    token.transferFrom(owner, msg.sender, _amount);
    SendTokens(owner, msg.sender, _amount);
  }

}
