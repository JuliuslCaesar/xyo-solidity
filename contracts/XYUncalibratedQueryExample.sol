pragma solidity ^0.4.19;

import "./XYUncalibratedQuery.sol";

contract XYUncalibratedQueryExample {

  address xyoAddress;

  XYUncalibratedQuery xyoOracle;

  function XYUncalibratedQueryExample(address _xyoAddress, address _xyoOracle) payable public {
    xyoOracle = XYUncalibratedQuery(_xyoOracle);
    //xyoOracle.publishQuery.value(msg.value)();
  }

}
