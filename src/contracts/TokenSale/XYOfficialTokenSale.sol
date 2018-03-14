pragma solidity ^0.4.19;

import "./XYEligibleTokenSale.sol";
import "./lib/XYVariablePrice.sol";

contract XYOfficialTokenSale is XYEligibleTokenSale {

  uint numberSold = 0;
  uint startVariablePrice; // = 100000000000000000000000; //18 places
  uint endVariablePrice; // = 33333333333333333333333; //18 places
  uint maxVariableAvailable; // = 36000000000; //0 places
  uint maxFixedAvailable; // = 900000000000; //0 places

  function XYOfficialTokenSale(
      address _token,
      uint _minEther,
      uint _startTime,
      uint _endTime,
      uint _startVariablePrice,
      uint _endVariablePrice,
      uint _maxVariableAvailable,
      uint _maxFixedAvailable)
  public XYEligibleTokenSale(_token, _startVariablePrice, _minEther, _startTime, _endTime) {
    startVariablePrice = _startVariablePrice; //18 places
    endVariablePrice = _endVariablePrice; //18 places
    maxVariableAvailable = _maxVariableAvailable; //0 places
    maxFixedAvailable = _maxFixedAvailable; //0 places
  }

  function setPrice(uint) public onlyOwner notKilled {
    //price is not settable from outside
    revert();
  }

  function getPrice() public view notKilled returns(uint) {
    return _tokensFromEther(1);
  }

  function predictCost(uint _ethAmount) public view notKilled returns(uint) {
    return _tokensFromEther(_ethAmount);
  }

  function _tokensFromEther(uint _ethAmount) internal view notKilled returns(uint){
    return XYVariablePrice.getTokensForEther(numberSold, _ethAmount, startVariablePrice, endVariablePrice, maxVariableAvailable, maxFixedAvailable);
  }

}
