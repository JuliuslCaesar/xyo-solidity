pragma solidity ^ 0.4 .2;

import "./XYKillable.sol";

contract XYLimitedTime is XYKillable {
  uint private startTime; //when the sale starts (0 = right away)
  uint private endTime; //when the sale ends (0 = never)

  function XYLimitedTime (uint _startTime, uint _endTime) public {
    startTime = _startTime;
    endTime = _endTime;
  }

  function setStartTime(uint _startTime) public onlyOwner notKilled {
    startTime = _startTime;
  }

  function setEndTime(uint _endTime) public onlyOwner notKilled {
    endTime = _endTime;
  }

  function isLive() public view returns(bool) {
    bool live = true;
    if (isKilled) {
      live = false;
    } else if (startTime > 0) {
      if (startTime > now) {
        live = false;
      }
    } else if (endTime > 0) {
      if (endTime < now) {
        live = false;
      }
    }
    return live;
  }

  modifier live() {
    require(isLive());
    _;
  }

  modifier notLive() {
    require(!isLive());
    _;
  }

}
