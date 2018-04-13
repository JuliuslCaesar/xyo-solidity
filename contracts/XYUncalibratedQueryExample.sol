pragma solidity ^0.4.19;

import "./XYUncalibratedQuery.sol";

contract XYUncalibratedQueryExample is XYUncalibratedQueryNotify {


  XYUncalibratedQuery xyoOracle;

  function XYUncalibratedQueryExample(address _xyoOracle) payable public {
    xyoOracle = XYUncalibratedQuery(_xyoOracle);
    //xyoOracle.publishQuery.value(msg.value)();
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
