pragma solidity ^0.4.21;

import "./XYPendingTokenSale.sol";
import "./lib/XYProofOfEligibility.sol";

contract XYEligibleTokenSale is XYPendingTokenSale, XYProofOfEligibility {

  function XYEligibleTokenSale(address _token, uint _price, uint _minEther, uint _startTime, uint _endTime)
  public XYPendingTokenSale(_token, _price, _minEther, _startTime, _endTime) {}

  function approve(address _buyer, address _proofOfEligibility) public onlyApprovers notKilled {
    setEligiblity(_buyer, _proofOfEligibility);
    require(!isBlocked(_buyer));
    super.approve(_buyer);
  }

  //this should never be used, but it prevents a call-around
  function approve(address _buyer) public onlyApprovers onlyNotBlocked onlyEligible notKilled {
    super.approve(_buyer);
  }

  function _purchase(uint _ethAmount, uint _tokenAmount) internal onlyNotBlocked {
    address buyer = msg.sender;
    super._purchase(_ethAmount, _tokenAmount);

    //if the buyer is eligible, auto approve
    if (getEligiblity(buyer) != 0) {
      _approve(buyer);
    }
  }
}
