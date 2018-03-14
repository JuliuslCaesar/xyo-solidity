pragma solidity ^0.4.19;

import "./SafeMath.sol";

library XYVariablePrice {
  using SafeMath
  for * ;

  // we assume a variable sale followed by a fixed sale, with the fixed sale being at the price of the final variable sale price

  function getTokensForEther(
      uint _numberSold, // 18 places
      uint _ether, // 18 places
      uint _startVariablePrice, // 18 places
      uint _endVariablePrice, // 18 places
      uint _maxVariableAvailable, // 0 places
      uint _maxFixedAvailable) // 0 places
  internal pure returns(uint) {
    require(_numberSold <= _maxVariableAvailable + _maxFixedAvailable);
    if (_isVariableSoldOut(_numberSold, _maxVariableAvailable)) {
      if (_isFixedSoldOut(_numberSold, _maxVariableAvailable, _maxFixedAvailable)) {
        // no tokens left
        return 0;
      } else {
        // only fixed tokens left
        return _getFixedTokensForEther(_numberSold, _ether, _endVariablePrice, _maxVariableAvailable, _maxFixedAvailable);
      }
    } else {
      uint maxEtherSpendableOnVariable = _getMaxEtherSpendableOnVariable(_numberSold, _startVariablePrice, _endVariablePrice, _maxVariableAvailable);
      uint desiredVariableTokens = _getVariableTokensForEther(_numberSold, _ether, _startVariablePrice, _endVariablePrice, _maxVariableAvailable);
      if (maxEtherSpendableOnVariable > _ether) {
        //entire transaction from variable
        return desiredVariableTokens;
      } else {
        //part variable and part fixed
        uint etherLeftForFixed = _ether - maxEtherSpendableOnVariable;
        uint maxEtherSpendableOnFixed = _getMaxEtherSpendableOnFixed(_numberSold, _endVariablePrice, _maxVariableAvailable, _maxFixedAvailable);
        uint desiredFixedTokens = _getFixedTokensForEther(_numberSold, etherLeftForFixed, _endVariablePrice, _maxVariableAvailable, _maxFixedAvailable);

        if (maxEtherSpendableOnFixed + maxEtherSpendableOnVariable < _ether) {
          //last buyer, selling all remaining tokens - we do this to assure no rounding at end
          return _getMaxAvailableForSale(_numberSold, _maxVariableAvailable, _maxFixedAvailable);
        } else {
          return desiredVariableTokens + desiredFixedTokens;
        }
      }
    }
  }

  function _getMaxAvailableForSale(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    if (_isFixedSoldOut(_numberSold, _maxVariableAvailable, _maxFixedAvailable)) {
      return 0;
    }
    return _numberSold - (_maxVariableAvailable - _maxFixedAvailable);
  }

  function _isVariableSoldOut(uint _numberSold, uint _maxVariableAvailable) internal pure returns(bool) {
    return _numberSold >= _maxVariableAvailable;
  }

  function _isFixedSoldOut(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(bool) {
    return _numberSold >= (_maxVariableAvailable + _maxFixedAvailable);
  }

  function _getFixedTokensForEther(
    uint _numberSold,
    uint _ether,
    uint _endVariablePrice,
    uint _maxVariableAvailable,
    uint _maxFixedAvailable)
  internal pure returns(uint) {
    uint maxFixedAvailable = _getMaxFixedAvailableForSale(_numberSold, _maxVariableAvailable, _maxFixedAvailable);
    uint desired = _ether / _endVariablePrice;
    if (desired <= maxFixedAvailable) {
      return desired;
    } else {
      return maxFixedAvailable;
    }
  }

  // the maximum amount of ether a buyer can spend on variable priced tokens
  function _getMaxEtherSpendableOnVariable(uint _numberSold, uint _startPrice, uint _endPrice, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable < _numberSold) {
      return 0;
    }
    uint middlePointPrice = _getPriceAtPoint(_numberSold + (_maxVariableAvailable - _numberSold) / 2, _startPrice, _endPrice, _maxVariableAvailable);
    uint remainingVariable = _maxVariableAvailable - _numberSold;
    return middlePointPrice * remainingVariable;
  }

  function _getVariableTokensForEther(
    uint _numberSold,
    uint _ether,
    uint _startVariablePrice,
    uint _endVariablePrice,
    uint _maxVariableAvailable)
  internal pure returns(uint) {
    if (_numberSold >= _maxVariableAvailable) {
      return 0;
    } else {
      uint ratio = _variableRatio(_startVariablePrice, _endVariablePrice, _maxVariableAvailable);
      //they both start with 10^18 so we divide both by 10^9 so that the 10^18 is reserved
      uint floorPrice = SafeMath.mul(SafeMath.div(_ether, 1000000000), SafeMath.div(ratio, 1000000000));
      uint tokens = _ether / floorPrice;
      uint maxVariableTokens = _getMaxVariableAvailableForSale(_numberSold, _maxVariableAvailable);
      if (tokens > maxVariableTokens) {
        return maxVariableTokens;
      } else {
        return tokens;
      }
    }
  }

  // the maximum amount of ether a buyer can spend on fixed priced tokens
  function _getMaxEtherSpendableOnFixed(uint _numberSold, uint _endPrice, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable < _numberSold) {
      return _maxFixedAvailable * _endPrice;
    } else if (_maxVariableAvailable + _maxFixedAvailable <= _numberSold) {
      return 0;
    } else {
      return _endPrice * _getRemainingFixed(_numberSold, _maxVariableAvailable, _maxFixedAvailable);
    }
  }

  function _getRemainingFixed(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    if (_numberSold >= _maxFixedAvailable + _maxVariableAvailable) {
      return 0;
    } else if (_numberSold >= _maxVariableAvailable) {
      return _maxFixedAvailable;
    } else {
      return _maxFixedAvailable - (_numberSold - _maxVariableAvailable);
    }
  }

  function _getMaxFixedAvailableForSale(uint _numberSold, uint _maxVariableAvailable, uint _maxFixedAvailable) internal pure returns(uint) {
    require(_numberSold <= _maxVariableAvailable + _maxFixedAvailable);
    if (_numberSold < _maxVariableAvailable) {
      return _maxFixedAvailable;
    } else {
      uint fixedSoldToDate = _numberSold - _maxVariableAvailable;
      return _maxFixedAvailable - fixedSoldToDate;
    }
  }

  function _getPriceAtPoint(uint _numberSold, uint _startPrice, uint _endPrice, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_numberSold >= _maxVariableAvailable) {
      return _endPrice;
    } else {
      uint delta = (_startPrice - _endPrice) * _numberSold / _maxVariableAvailable;
      return _startPrice + delta;
    }
  }

  // this calculates the percent of the cost that is in the rectangle (18 places)
  function _variableRatio(uint _startPrice, uint _endPrice, uint _maxVariableAvailable) internal pure returns(uint) {
    uint rect = _maxVariableAvailable * _startPrice; //18 places
    uint triangle = (_maxVariableAvailable * (_startPrice - _endPrice)) / 2;
    return (rect - triangle) / _maxVariableAvailable;
  }

  function _getMaxVariableAvailableForSale(uint _numberSold, uint _maxVariableAvailable) internal pure returns(uint) {
    if (_maxVariableAvailable > _numberSold) {
      return _maxVariableAvailable - _numberSold;
    } else {
      return 0;
    }
  }

}
