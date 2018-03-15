pragma solidity ^ 0.4 .19;

import "./XYTokenSale.sol";

contract XYTimedTokenSale is XYTokenSale {

  uint public startTime; //when the sale starts (0 = right away)
  uint public endTime; //when the sale ends (0 = never)

  function XYTimedTokenSale(address _token, uint _price, uint _minEther, uint _startTime, uint _endTime)
  XYTokenSale(_token, _price, _minEther)
  public {
    startTime = _startTime;
    endTime = _endTime;
  }

  function _purchase(uint _ethAmount, uint _tokenAmount) internal live notKilled {
    super._purchase(_ethAmount, _tokenAmount);
  }

  function setStartTime(uint _startTime) public onlyOwner notKilled {
    startTime = _startTime;
  }

  function setEndTime(uint _endTime) public onlyOwner notKilled {
    endTime = _endTime;
  }

  function isLive() public view returns(bool) {
    bool live = true;
    if (isKilled()) {
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
