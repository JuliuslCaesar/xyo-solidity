pragma solidity ^0.4.2;

import "./XYTokenSale.sol";

contract XYTimedTokenSale is XYTokenSale {

    uint public startTime; //when the sale starts (0 = right away)
    uint public endTime; //when the sale ends (0 = never)

    function XYTimedTokenSale(address _token, address _beneficiary, uint _price, uint _tokensAvailable, uint _minEther, uint _startTime, uint _endTime)
      XYTokenSale(_token, _beneficiary, _price, _tokensAvailable, _minEther)
    public {
      startTime = _startTime;
      endTime = _endTime;
      setAvailableTokens(_tokensAvailable);
    }

    function setStartTime(uint _startTime) public onlySeller {
      startTime = _startTime;
    }

    function setEndTime(uint _endTime) public onlySeller {
      endTime = _endTime;
    }

    function isLive() public view returns (bool) {
      bool live = true;
      if (startTime > 0) {
        if (startTime > now) {
          live = false;
        }
      }
      if (endTime > 0) {
        if (endTime < now) {
          live = false;
        }
      }
      return live;
    }

    function _purchase() internal {
      require(isLive());
      super._purchase();
    }

    modifier onlyWhenLive() {
        require(isLive());
        _;
    }

}
