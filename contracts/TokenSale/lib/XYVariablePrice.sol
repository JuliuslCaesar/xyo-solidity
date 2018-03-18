pragma solidity ^ 0.4 .19;
import "./SafeMath.sol";
library XYVariablePrice {
  using SafeMath
  for * ;
  // we assume a Token Sale beginning with a Variable pricing model followed by a Fixed pricing model
  // Final Variable sale price establishes the final Fixed sale price
  // the Token Sale is comprised of individual Transactions that require an input of Ether for an output of Tokens
  // each Transaction has a Start Price and End Price
  // Price is contingent on Token Availability as well as Desired Tokens to be purchased with Ether
  function getTokensForEther(
    uint _numberSold, // 18 places, total Tokens sold to-date
    uint _ether, // 18 places, Ether input into Transaction
    uint _startVariablePrice, // 18 places, Variable Token start price at beginning of Token Sale
    uint _endVariablePrice, // 18 places, Variable Token end price at beginning of Token Sale
    uint _maxVariableAvailableIn, // 0 places, total Variable-priced Tokens available at start of Token Sale
    uint _maxFixedAvailableIn) // 0 places, total Fixed-priced Tokens available at start of Token Sale prior
  internal pure returns(uint) {
    uint maxVariableAvailable = _maxVariableAvailableIn * (10 ** 18);
    uint maxFixedAvailable = _maxFixedAvailableIn * (10 ** 18);
    if (_numberSold >= maxVariableAvailable + maxFixedAvailable) // make sure Tokens are available for Transaction
    {
      return 0;
    }
    if (_isVariableSoldOut(_numberSold, maxVariableAvailable)) // check if Variable-priced Tokens are sold out
    {
      if (_isFixedSoldOut(_numberSold, maxVariableAvailable, maxFixedAvailable)) // check if Fixed-priced Tokens are sold out
      {
        return 0; // return 0 Fixed-price Tokens for Transaction
      } else // case where Fixed-price Tokens are available for Transaction
      {
        return _getDesiredFixedTokensForEther(_numberSold, _ether, _endVariablePrice, maxVariableAvailable, maxFixedAvailable); // return desired Fixed-priced Tokens for Transaction (or maximum available if final Transaction)
      }
    }
    else // case where Variable-priced Tokens are available for Transaction
    {
      uint maxEtherSpendableOnVariable = _getMaxEtherSpendableOnVariable(_numberSold, _startVariablePrice, _endVariablePrice, maxVariableAvailable); // maximum amount of Ether that can be spent on Variable-priced Tokens
      uint desiredVariableTokens = _getDesiredVariableTokensForEther(_numberSold, _ether, _startVariablePrice, _endVariablePrice, maxVariableAvailable); // desired Variable-priced Tokens for Transaction (or maximum available if final Transaction at Variable price)
      if (maxEtherSpendableOnVariable > _ether) // check if all desired Tokens can be fulfilled by Variable-priced Tokens
      {
        return desiredVariableTokens; // return all desired tokens as Variable-priced Tokens
      } else // case where desired Tokens are partially fulfilled by Variable-priced Tokens and partially fulfilled by Fixed-price Tokens
      {
        uint etherLeftForFixed = _ether - maxEtherSpendableOnVariable; // Ether remaining for Fixed-priced Tokens
        uint maxEtherSpendableOnFixed = _getMaxEtherSpendableOnFixed(_numberSold, _endVariablePrice, maxVariableAvailable, maxFixedAvailable); // maximum Ether available to be spent on Fixed-priced Tokens
        uint desiredFixedTokens = _getDesiredFixedTokensForEther(_numberSold, etherLeftForFixed, _endVariablePrice, maxVariableAvailable, maxFixedAvailable);
        if (SafeMath.add(maxEtherSpendableOnFixed, maxEtherSpendableOnVariable) < _ether) // check if final Transaction in Token Sale to assure no rounding at end
        {
          return _getMaxTokensAvailableForTransaction(_numberSold, maxVariableAvailable, maxFixedAvailable); // return all available Tokens for final Transaction
        }
        else
        {
          return SafeMath.add(desiredVariableTokens, desiredFixedTokens); // return all desired Tokens
        }
      }
    }
  }
  // available Tokens for Transaction if Ether input is larger than the Token availability (the final Transaction)
  function _getMaxTokensAvailableForTransaction(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    if (_isFixedSoldOut(_numberSold, _maxVariableAvailable, _maxFixedAvailable)) // check if Fixed-priced Tokens are sold out
    {
      return 0; // return 0 Fixed-priced Tokens available for Transaction
    }
    else
    {
    return SafeMath.sub(SafeMath.add(_maxVariableAvailable, _maxFixedAvailable), _numberSold); // return all available Tokens
    }
  }
  function _isVariableSoldOut(uint _numberSold, uint _maxVariableAvailable) internal pure returns(bool)
  {
    return _numberSold >= _maxVariableAvailable;
  }
  function _isFixedSoldOut(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(bool)
  {
    return _numberSold >= (SafeMath.add(_maxVariableAvailable, _maxFixedAvailable));
  }
  // desired amount of Fixed-priced Tokens given Ether input, potentially for the final Transaction if Ether input is larger than Token availability
  function _getDesiredFixedTokensForEther(uint _numberSold, uint _ether, uint _endVariablePrice, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    uint maxFixedAvailableForTransaction = _getRemainingFixed(_numberSold, _maxVariableAvailable, _maxFixedAvailable);
    uint desiredFixedTokens = SafeMath.mul(_ether / (10 ** 9), _endVariablePrice / (10 ** 9));
    if (desiredFixedTokens <= maxFixedAvailableForTransaction) // check if all desired Tokens can be fulfilled by Fixed-priced Tokens
    {
      return desiredFixedTokens; // return all desired tokens as Fixed-priced Tokens
    } else
    {
      return maxFixedAvailableForTransaction; // return only available Fixed-priced Tokens
    }
  }
  // the maximum amount of Ether a buyer can spend on Variable-priced Tokens
  function _getMaxEtherSpendableOnVariable(uint _numberSold, uint _startPrice, uint _endPrice, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable < _numberSold) // check if Variable-priced Tokens are available
    {
      return 0; // return 0 Ether to spend on Variable-priced Tokens
    }
    else
    {
      uint remainingVariable = SafeMath.sub(_maxVariableAvailable, _numberSold);
      uint currentPrice = _getCurrentPrice(_numberSold, _startPrice, _endPrice, _maxVariableAvailable); // price element for Ether calculation
      return SafeMath.div(remainingVariable * (10 ** 9), currentPrice / (10 ** 9)); // returns the maximum amount of Ether that can be spent on Variable-priced Tokens
    }
  }
  // desired amount of Variable-priced Tokens given Ether input
  function _getDesiredVariableTokensForEther(uint _numberSold, uint _ether, uint _startVariablePrice, uint _endVariablePrice, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_numberSold >= _maxVariableAvailable) // check if Variable-priced Tokens are available
    {
      return 0; // return 0 Variable-priced Tokens
    } else {
      uint currentPrice = _getCurrentPrice(_numberSold, _startVariablePrice, _endVariablePrice, _maxVariableAvailable); // current price of Token based on Tokens sold to-date
      uint desiredTokens = SafeMath.mul(_ether, currentPrice / (10 ** 9)) / (10 ** 9); // amount of Variable-priced Tokens available given Ether input
      uint maxVariableTokens = _getMaxVariableAvailableForTransaction(_numberSold, _maxVariableAvailable); // maximum Variable-priced Tokens available
      if (desiredTokens > maxVariableTokens) // check if there are more desired Variable-priced Tokens than the amount available
      {
        return maxVariableTokens; // return the maximum amount of Variable-priced Tokens available
      } else {
        return desiredTokens; //return the full amount of desired Variable-priced Tokens
      }
    }
  }
  // the maximum amount of Ether a buyer can spend on Fixed-priced Tokens
  function _getMaxEtherSpendableOnFixed(uint _numberSold, uint _endPrice, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable > _numberSold) // check if there are Variable-priced Tokens available
    {
      return _maxFixedAvailable * _endPrice; // returns the maximum amount of Ether that can be spent on Fixed-priced Tokens
    }else if (SafeMath.add(_maxVariableAvailable, _maxFixedAvailable) <= _numberSold) // case where there are no Tokens available
    {
      return 0;
    }
    else // case where there not Variable-priced Tokens available
    {
      return SafeMath.mul(_endPrice / (10 ** 9), _getRemainingFixed(_numberSold, _maxVariableAvailable, _maxFixedAvailable) / (10 ** 9)); // return maxiumum amount of Ether that can be spent on remaining Fixed-priced Tokens
    }
  }
  // the maximum amount of Fixed-priced Tokens remaining to-date
  function _getRemainingFixed(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    if (_numberSold > SafeMath.add(_maxVariableAvailable, _maxFixedAvailable)) // make sure Tokens are available for Transaction
    {
      return 0;
    }
    if (_numberSold < _maxVariableAvailable) // check if Variable-priced Tokens are available
    {
      return _maxFixedAvailable; // return maximum amount of Fixed-priced Tokens
    }
    else
    {
      uint fixedSoldToDate = SafeMath.sub(_numberSold, _maxVariableAvailable); // amount of Fixed-priced Tokens sold to-date
      return SafeMath.sub(_maxFixedAvailable, fixedSoldToDate); // return the remaining Fixed-priced Tokens available
    }
  }
  // this calculates the Token Price at the number of Tokens sold to-date
  function _getCurrentPrice(uint _numberSold, uint _startPrice, uint _endPrice, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_numberSold >= _maxVariableAvailable) // check if Variable-priced are Tokens available
    {
      return _endPrice; // returns the end price
    }
    else {
      uint tokensAvailablePerEtherRange = SafeMath.sub(_startPrice, _endPrice); // the start and end price are defined in Tokens, so the start price is greater than the end price (in Tokens)
      uint percentComplete = SafeMath.div(_numberSold * (10 ** 9), (_maxVariableAvailable) * (10 ** 9)); // the percentage of Tokens sold to-date of the maximum Variable-priced Tokens available
      uint delta = SafeMath.mul(percentComplete / (10 ** 9), tokensAvailablePerEtherRange / (10 ** 9));  // the amount of Tokens available given the percentage of Tokens sold to-date
      return SafeMath.sub(_startPrice, delta); // returns the price at a given number of Tokens sold to-date
    }
  }
  // the maximum amoung of Variable-priced Tokens available to-date
  function _getMaxVariableAvailableForTransaction(uint _numberSold, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable > _numberSold) // check if Variable-priced Tokens are available
    {
      return SafeMath.sub(_maxVariableAvailable, _numberSold); // return the amount of Variable-priced Tokens available
    } else {
      return 0; // return 0 Variable-priced Tokens
    }
  }
}
