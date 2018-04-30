pragma solidity ^0.4.19;
pragma experimental "v0.5.0";

import "XYUncalibratedQuery.sol";

contract XYUncalibratedQueryExample is XYUncalibratedQueryNotify {


  XYUncalibratedQuery xyoOracle;

  constructor (address _xyoOracle) payable public {
    xyoOracle = XYUncalibratedQuery(_xyoOracle);
    xyoOracle.publishQuery.value(msg.value)(
      10, // xyoValue,
      0x1234567890, // xyoAddress,
      1, // accuracy,
      1, //certainty,
      30, //delay,
      0, //epoch,
      this);
  }

  function answer(
      address, //_xyoAddress,
      uint, // _index,
      int,  //_latitude,
      int, //_longitude,
      int, //_altitude,
      uint, //_accuracy,
      uint, //_certainty,
      uint) external { //_epoch

      }

}
