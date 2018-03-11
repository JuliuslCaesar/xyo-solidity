pragma solidity ^ 0.4 .2;

import "./SafeMath.sol";
import "./ERC20.sol";


contract XYTokenSale {
  using SafeMath
  for * ;

  ERC20 public token; //address of the ERC20 token
  address public seller; //address where tokens come from and unused tokens are returned to
  address public beneficiary; //address where the ETH payments go to
  uint public price; //price of tokens (how many tokens per ETH)
  uint public minEther; //minimum amount of Ether required for a purchase (0 for no minimum)
  bool public saleKilled; //once this is set to false, the contract is (mostly) dead

  event AcceptEther(address seller, address buyer, uint amount);
  event SendTokens(address seller, address buyer, uint amount);

  function XYTokenSale(address _token, address _beneficiary, uint _price, uint _minEther) public {
    seller = msg.sender;
    token = ERC20(_token);
    beneficiary = _beneficiary;
    price = _price;
    minEther = _minEther;
    saleKilled = false;
  }

  function() public payable {
    _purchase();
  }

  function getAvailableTokens() public view returns(uint) {
    return token.allowance(seller, this);
  }

  function setMinEther(uint _minEther) public onlySeller {
    minEther = _minEther;
  }

  function setPrice(uint _price) public onlySeller {
    price = _price;
  }

  // this marks the sale dead forever - no more transactions
  // also flushes all ETH and XYO from the contract to the seller
  function kill() public onlySeller {
    saleKilled = true;
    seller.transfer(this.balance);
    token.transferFrom(this, seller, token.balanceOf(this));
  }

  function _purchase() internal saleNotKilled {
    uint ethAmount = msg.value;
    uint tokenAmount = SafeMath.mul(ethAmount, price);

    require(tokenAmount <= getAvailableTokens());
    require(tokenAmount <= token.balanceOf(seller));
    require(ethAmount >= minEther || minEther == 0);

    _acceptEther(ethAmount);
    _sendTokens(tokenAmount);
  }

  function _acceptEther(uint _amount) internal saleNotKilled {
    seller.transfer(_amount);
    AcceptEther(seller, msg.sender, _amount);
  }

  function _sendTokens(uint _amount) internal saleNotKilled {
    token.transferFrom(seller, msg.sender, _amount);
    SendTokens(seller, msg.sender, _amount);
  }

  modifier onlySeller() {
    require(msg.sender == seller);
    _;
  }

  modifier saleNotKilled() {
    require(!saleKilled);
    _;
  }

}
