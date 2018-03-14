pragma solidity ^0.4.19;

import "./XYTokenSale.sol";
import "./lib/XYLimitedTime.sol";

contract XYTimedTokenSale is XYTokenSale, XYLimitedTime {

    function XYTimedTokenSale(address _token, uint _price, uint _minEther, uint _startTime, uint _endTime)
        XYTokenSale(_token, _price, _minEther) XYLimitedTime(_startTime, _endTime)
    public {
    }

    function _purchase(uint _ethAmount, uint _tokenAmount) internal live notKilled {
      super._purchase(_ethAmount, _tokenAmount);
    }

}
