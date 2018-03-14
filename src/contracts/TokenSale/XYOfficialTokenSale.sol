pragma solidity ^0.4.19;

import "./XYEligibleTokenSale.sol";
import "./lib/XYVariablePrice.sol";

contract XYOfficialTokenSale is XYEligibleTokenSale {

  uint numberSold = 0;
  uint startPrice; // = 100000000000000000000000; //18 places
  uint endPrice; // = 33333333333333333333333; //18 places
  uint totalVariableTokens; // = 36000000000; //0 places
  uint totalFixedTokens; // = 9000000000; //0 places

  function XYOfficialTokenSale(
      address _token,
      uint _minEther,
      uint _startTime,
      uint _endTime,
      uint _startPrice,
      uint _endPrice,
      uint _totalVariableTokens,
      uint _totalFixedTokens)
  public XYEligibleTokenSale(_token, _startPrice, _minEther, _startTime, _endTime) {
    startPrice = _startPrice; //18 places
    endPrice = _endPrice; //18 places
    totalVariableTokens = _totalVariableTokens; //0 places
    totalFixedTokens = _totalFixedTokens; //0 places
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
    return XYVariablePrice.getTokensForEther(numberSold, _ethAmount, startPrice, endPrice, totalVariableTokens, totalFixedTokens);
  }

}
