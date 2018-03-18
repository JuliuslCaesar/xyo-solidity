pragma solidity ^0.4.19;

import "./XYEligibleTokenSale.sol";
import "./lib/XYVariablePrice.sol";

contract XYOfficialTokenSale is XYEligibleTokenSale {

  uint public numberSold;
  uint public startPrice; // 18 places
  uint public endPrice; // 18 places
  uint public totalVariableTokens; // 0 places
  uint public totalFixedTokens; // 0 places

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

  function _sendTokens(uint _amount) internal {
    super._sendTokens(_amount);
    numberSold = numberSold + _amount * 1000;
  }

  function setPrice(uint) public onlyOwner onlyNotKilled {
    //price is not settable from outside
    revert();
  }

  function getPrice() public view onlyNotKilled returns(uint) {
    return _tokensFromEther(1000000000000000000);
  }

  function predictTokensForEther(uint _ethAmount, uint _numberSold) public view onlyNotKilled returns(uint) {
    return XYVariablePrice.getTokensForEther(_numberSold, _ethAmount, startPrice, endPrice, totalVariableTokens, totalFixedTokens);
  }

  function _tokensFromEther(uint _ethAmount) internal view onlyNotKilled returns(uint){
    return XYVariablePrice.getTokensForEther(numberSold, _ethAmount, startPrice, endPrice, totalVariableTokens, totalFixedTokens);
  }

}
