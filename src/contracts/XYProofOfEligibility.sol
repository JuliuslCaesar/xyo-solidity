pragma solidity ^0.4.19;

import "XYApprovable.sol";

contract XYProofOfEligibility is XYApprovable {

  // Stores a mapping of wallet eligibility state
  // The address can be whatever the caller wants
  // 0 = Not yet XYEligible
  // setting eligibility is permanent
  mapping(address => byte[]) public eligible;

  function setEligiblity(address _wallet, byte[] _proof) public onlyApprovers {
    require(eligible[_wallet].length == 0);
    require(_proof.length <= 128);
    eligible[_wallet] = _proof;
  }

  modifier onlyEligible() {
    require(eligible[msg.sender].length > 0);
    _;
  }

  modifier onlyIneligible() {
    require(eligible[msg.sender].length > 0);
    _;
  }

}
