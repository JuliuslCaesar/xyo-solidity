pragma solidity ^0.4.19;
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
    uint _maxVariableAvailable, // 0 places, total Variable-priced Tokens available at start of Token Sale
    uint _maxFixedAvailable) // 0 places, total Fixed-priced Tokens available at start of Token Sale prior
  internal pure returns(uint) {
    require(_numberSold <= _maxVariableAvailable + _maxFixedAvailable); // make sure Tokens are available for Transaction
    if (_isVariableSoldOut(_numberSold, _maxVariableAvailable)) // check if Variable-priced Tokens are sold out
    {
      if (_isFixedSoldOut(_numberSold, _maxVariableAvailable, _maxFixedAvailable)) // check if Fixed-priced Tokens are sold out
      {
        return 0; // return 0 Fixed-price Tokens for Transaction
      } else // case where Fixed-price Tokens are available for Transaction
      {
        return _getDesiredFixedTokensForEther(_numberSold, _ether, _endVariablePrice, _maxVariableAvailable, _maxFixedAvailable); // return Fixed Tokens for Transaction
      }
    } else // case where Variable-priced Tokens are available for Transaction
    {
      uint maxEtherSpendableOnVariable = _getMaxEtherSpendableOnVariable(_numberSold, _startVariablePrice, _endVariablePrice, _maxVariableAvailable);
      uint desiredVariableTokens = _getDesiredVariableTokensForEther(_numberSold, _ether, _startVariablePrice, _endVariablePrice, _maxVariableAvailable);
      if (maxEtherSpendableOnVariable > _ether) // check if all desired Tokens can be fulfilled by Variable-priced Tokens
      {
        return desiredVariableTokens; // return all desired tokens as Variable-priced Tokens
      } else // case where desired Tokens are partially fulfilled by Variable-priced Tokens and partially fulfilled by Fixed-price Tokens
      {
        uint etherLeftForFixed = _ether - maxEtherSpendableOnVariable;
        uint maxEtherSpendableOnFixed = _getMaxEtherSpendableOnFixed(_numberSold, _endVariablePrice, _maxVariableAvailable, _maxFixedAvailable);
        uint desiredFixedTokens = _getDesiredFixedTokensForEther(_numberSold, etherLeftForFixed, _endVariablePrice, _maxVariableAvailable, _maxFixedAvailable);
        if (maxEtherSpendableOnFixed + maxEtherSpendableOnVariable < _ether) // check if final Transaction in Token Sale to assure no rounding at end
        {
          return _getMaxTokensAvailableForTransaction(_numberSold, _maxVariableAvailable, _maxFixedAvailable); // return all available Tokens for final Transaction
        } else {
          return desiredVariableTokens + desiredFixedTokens; // return all desired Tokens
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
    return (_maxVariableAvailable + _maxFixedAvailable) - _numberSold; // return all available Tokens
  }

  function _isVariableSoldOut(uint _numberSold, uint _maxVariableAvailable) internal pure returns(bool) {
    return _numberSold >= _maxVariableAvailable;
  }

  function _isFixedSoldOut(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(bool) {
    return _numberSold >= (_maxVariableAvailable + _maxFixedAvailable);
  }

  // desired amount of Fixed-priced Tokens given Ether input, potentially for the final Transaction if Ether input is larger than Token availability
  function _getDesiredFixedTokensForEther(uint _numberSold, uint _ether, uint _endVariablePrice, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    uint maxFixedAvailableForTransaction = _getMaxFixedAvailableForTransaction(_numberSold, _maxVariableAvailable, _maxFixedAvailable);
    uint desiredFixedTokens = _ether / _endVariablePrice;
    if (desiredFixedTokens <= maxFixedAvailableForTransaction) // check if all desired Tokens can be fulfilled by Fixed-priced Tokens
    {
      return desiredFixedTokens; // return all desired tokens as Fixed-priced Tokens
    } else {
      return maxFixedAvailableForTransaction; // return only available Fixed-priced Tokens
    }
  }

  // the maximum amount of Ether a buyer can spend on Variable-priced Tokens
  function _getMaxEtherSpendableOnVariable(uint _numberSold, uint _startPrice, uint _endPrice, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable < _numberSold) // check if Variable-priced Tokens are available
    {
      return 0; // return 0 Ether to spend on Variable-priced Tokens
    }
    uint middlePointPrice = _getPriceAtPoint(_numberSold + (_maxVariableAvailable - _numberSold) / 2, _startPrice, _endPrice, _maxVariableAvailable); // price element for Ether calculation
    uint remainingVariable = _maxVariableAvailable - _numberSold; // volume element for Ether calculation
    return middlePointPrice * remainingVariable; // returns the maximum amount of Ether that can be spent on Variable-priced Tokens
  }

  // desired amount of Variable-priced Tokens given Ether input
  function _getDesiredVariableTokensForEther(uint _numberSold, uint _ether, uint _startVariablePrice, uint _endVariablePrice, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_numberSold >= _maxVariableAvailable) // check if Variable-priced Tokens are available
    {
      return 0; // return 0 Variable-priced Tokens
    } else {
      uint variableRatio = _variableRatio(_startVariablePrice, _endVariablePrice, _maxVariableAvailable); // Variable Token price ratio used to calculate desired Variable-priced Token cost
      uint floorPrice = SafeMath.mul(SafeMath.div(_ether, 1000000000), SafeMath.div(variableRatio, 1000000000)); // Variable Token price at the start of the transaction. Both variable lengths in the calculation start with 10^18, so division by 10^9 is calculated to preserve the 10^18 length
      uint tokens = _ether / floorPrice; //amount of Variable-priced Tokens available given Ether input
      uint maxVariableTokens = _getMaxVariableAvailableForTransaction(_numberSold, _maxVariableAvailable); // maximum Variable-priced Tokens available
      if (tokens > maxVariableTokens) // check if there are more desired Variable-priced Tokens than the amount available
      {
        return maxVariableTokens; // return the maximum amount of Variable-priced Tokens available
      } else {
        return tokens; //return the full amount of desired Variable-priced Tokens
      }
    }
  }

  // the maximum amount of Ether a buyer can spend on Fixed-priced Tokens
  function _getMaxEtherSpendableOnFixed(uint _numberSold, uint _endPrice, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable > _numberSold) // check if there are Variable-priced Tokens available
    {
      return _maxFixedAvailable * _endPrice; // returns the maximum amount of Ether that can be spent on Fixed-priced Tokens
    } else if (_maxVariableAvailable + _maxFixedAvailable <= _numberSold) // case where there are no Tokens available
    {
      return 0;
    } else // case where there not Variable-priced Tokens available
    {
      return _endPrice * _getRemainingFixed(_numberSold, _maxVariableAvailable, _maxFixedAvailable); // return maxiumum amount of Ether that can be spent on remaining Fixed-priced Tokens
    }
  }

  // the remaining Fixed-price Tokens available to-date
  function _getRemainingFixed(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    if (_numberSold >= _maxFixedAvailable + _maxVariableAvailable) // check if there are Tokens available
    {
      return 0; // return 0 Fixed-priced Tokens
    } else if (_numberSold >= _maxVariableAvailable) // case where
    {
      return _maxFixedAvailable;
    } else {
      return _maxFixedAvailable - (_numberSold - _maxVariableAvailable);
    }
  }

  // the maximum amoung of Fixed-priced Tokens available to-date
  function _getMaxFixedAvailableForTransaction(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    require(_numberSold <= _maxVariableAvailable + _maxFixedAvailable); // make sure Tokens are available for Transaction

    if (_numberSold < _maxVariableAvailable) // check if Variable-priced Tokens are available
    {
      return _maxFixedAvailable; // return maximum amount of Fixed-priced Tokens
    } else {
      uint fixedSoldToDate = _numberSold - _maxVariableAvailable; // amount of Fixed-priced Tokens sold to-date
      return _maxFixedAvailable - fixedSoldToDate; // return the remaining Fixed-priced Tokens available
    }
  }

  // this calculates the Token Price at the number of Tokens sold to-date
  function _getPriceAtPoint(uint _numberSold, uint _startPrice, uint _endPrice, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_numberSold >= _maxVariableAvailable) // check if Variable-priced are Tokens available
    {
      return _endPrice; // returns the end price
    } else {
      uint delta = (_endPrice - _startPrice) * _numberSold / _maxVariableAvailable; // the difference in price between the start price and the price at a given number of Tokens sold to-date [changed from (startPrice - endPrice)]
      return _startPrice + delta; // returns the price at a given number of Tokens sold to-dat
    }
  }

  // the ratio of the variable cost to the cost contained in the rectangle calculated from the start and end price (18 places)
  function _variableRatio(uint _startPrice, uint _endPrice, uint _maxVariableAvailable) internal pure returns(uint) {
    uint rect = _maxVariableAvailable * _startPrice; // 18 places, area of the rectangle (total cost) calculated from the start and end price
    uint triangle = (_maxVariableAvailable * (_startPrice - _endPrice)) / 2; //area of the triangle calculated from the midpoint of the start and end price that lies directly outside the rectangle
    return (rect - triangle) / _maxVariableAvailable; // returns the ratio of the the total cost contained within the rectangle
  }

  // the maximum amoung of Variable-priced Tokens available to-date
  function _getMaxVariableAvailableForTransaction(uint _numberSold, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable > _numberSold) // check if Variable-priced Tokens are available
    {
      return _maxVariableAvailable - _numberSold; // return the amount of Variable-priced Tokens available
    } else {
      return 0; // return 0 Variable-priced Tokens
    }
  }
}
