pragma solidity ^ 0.4 .19;

import "XYTokenSale.sol";

contract XYTimedTokenSale is XYTokenSale {

  uint public startTime; //when the sale starts (0 = right away)
  uint public endTime; //when the sale ends (0 = never)

  constructor(address _token, address _beneficiary, uint _price, uint _minEther, uint _startTime, uint _endTime)
  XYTokenSale(_token, _beneficiary, _price, _minEther)
  public {
    startTime = _startTime;
    endTime = _endTime;
  }

  function _purchase(uint _ethAmount, uint _tokenAmount) internal live onlyNotKilled {
    super._purchase(_ethAmount, _tokenAmount);
  }

  function setStartTime(uint _startTime) public onlyOwner onlyNotKilled {
    startTime = _startTime;
  }

  function setEndTime(uint _endTime) public onlyOwner onlyNotKilled {
    endTime = _endTime;
  }

  function isLive() public view returns(bool) {
    bool live = true;
    if (killed) {
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
