pragma solidity ^0.4.19;

import "XYVariablePrice.sol";


contract XYVariablePriceTest {
  using XYVariablePrice
  for * ;

  function getTokensForEther(
    uint _numberSold, // 18 places, total Tokens sold to-date
    uint _ether, // 18 places, Ether input into Transaction
    uint _startVariablePrice, // 18 places, Variable Token start price at beginning of Token Sale
    uint _endVariablePrice, // 18 places, Variable Token end price at beginning of Token Sale
    uint _maxVariableAvailableIn, // 0 places, total Variable-priced Tokens available at start of Token Sale
    uint _maxFixedAvailableIn) // 0 places, total Fixed-priced Tokens available at start of Token Sale prior
  public pure returns(uint) {
    return XYVariablePrice.getTokensForEther(
      _numberSold,
      _ether,
      _startVariablePrice,
      _endVariablePrice,
      _maxVariableAvailableIn,
      _maxFixedAvailableIn);
  }

  function getMaxTokensAvailableForTransaction(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) public pure returns(uint) {
    return XYVariablePrice._getMaxTokensAvailableForTransaction(
      _numberSold,
      _maxVariableAvailable,
      _maxFixedAvailable
      );
  }
  function isVariableSoldOut(uint _numberSold, uint _maxVariableAvailable) public pure returns(bool)
  {
    return XYVariablePrice._isVariableSoldOut(
      _numberSold,
      _maxVariableAvailable
      );
  }
  function isFixedSoldOut(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) public pure returns(bool)
  {
    return XYVariablePrice._isFixedSoldOut(
      _numberSold,
      _maxVariableAvailable,
      _maxFixedAvailable
      );
  }
  // desired amount of Fixed-priced Tokens given Ether input, potentially for the final Transaction if Ether input is larger than Token availability
  function getDesiredFixedTokensForEther(uint _numberSold, uint _ether, uint _endVariablePrice, uint _maxVariableAvailable, uint _maxFixedAvailable) public pure returns(uint) {
    return XYVariablePrice._getDesiredFixedTokensForEther(
      _numberSold,
      _ether,
      _endVariablePrice,
      _maxVariableAvailable,
      _maxFixedAvailable
      );
  }
  // the maximum amount of Ether a buyer can spend on Variable-priced Tokens
  function getMaxEtherSpendableOnVariable(uint _numberSold, uint _startPrice, uint _endPrice, uint _maxVariableAvailable) public pure returns(uint) {
    return XYVariablePrice._getMaxEtherSpendableOnVariable(
      _numberSold,
      _startPrice,
      _endPrice,
      _maxVariableAvailable
      );
  }
  // desired amount of Variable-priced Tokens given Ether input
  function getDesiredVariableTokensForEther(uint _numberSold, uint _ether, uint _startVariablePrice, uint _endVariablePrice, uint _maxVariableAvailable) public pure returns(uint) {
    return XYVariablePrice._getDesiredVariableTokensForEther(
      _numberSold,
      _ether,
      _startVariablePrice,
      _endVariablePrice,
      _maxVariableAvailable
      );
  }
  // the maximum amount of Ether a buyer can spend on Fixed-priced Tokens
  function getMaxEtherSpendableOnFixed(uint _numberSold, uint _endPrice, uint _maxVariableAvailable, uint _maxFixedAvailable) public pure returns(uint) {
    return XYVariablePrice._getMaxEtherSpendableOnFixed(
      _numberSold,
      _endPrice,
      _maxVariableAvailable,
      _maxFixedAvailable
      );
  }
  // the maximum amount of Fixed-priced Tokens remaining to-date
  function getRemainingFixed(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) public pure returns(uint) {
    return XYVariablePrice._getRemainingFixed(
      _numberSold,
      _maxVariableAvailable,
      _maxFixedAvailable
      );
  }
  // this calculates the Token Price at the number of Tokens sold to-date
  function getCurrentPrice(uint _numberSold, uint _startPrice, uint _endPrice, uint _maxVariableAvailable) public pure returns(uint) {
    return XYVariablePrice._getCurrentPrice(
      _numberSold,
      _startPrice,
      _endPrice,
      _maxVariableAvailable
      );
  }
  // the maximum amoung of Variable-priced Tokens available to-date
  function getMaxVariableAvailableForTransaction(uint _numberSold, uint _maxVariableAvailable) public pure returns(uint) {
    return XYVariablePrice._getMaxVariableAvailableForTransaction(
      _numberSold,
      _maxVariableAvailable
      );
  }

}
