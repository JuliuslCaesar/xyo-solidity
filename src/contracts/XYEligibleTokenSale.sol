pragma solidity ^0.4.19;

import "XYPendingTokenSale.sol";
import "XYProofOfEligibility.sol";

contract XYEligibleTokenSale is XYPendingTokenSale, XYProofOfEligibility {

  constructor(address _token, address _beneficiary, uint _price, uint _minEther, uint _startTime, uint _endTime)
  public XYPendingTokenSale(_token, _beneficiary, _price, _minEther, _startTime, _endTime) {}

  function approve(address _buyer, byte[] _proofOfEligibility) public onlyApprovers onlyNotKilled {
    require(!blocked[_buyer]);
    setEligiblity(_buyer, _proofOfEligibility);
    _approve(_buyer);
  }

  //this should never be used, but it prevents a call-around
  function approve(address _buyer) public onlyApprovers {
    revert();
    _approve(_buyer);
  }

  function _purchase(uint _ethAmount, uint _tokenAmount) internal onlyNotBlocked {
    address buyer = msg.sender;
    super._purchase(_ethAmount, _tokenAmount);

    //if the buyer is eligible, auto approve
    if (eligible[buyer].length > 0) {
      _approve(buyer);
    }
  }
}
