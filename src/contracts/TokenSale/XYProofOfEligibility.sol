pragma solidity ^0.4.19;

import "./XYApprovable.sol";

contract XYProofOfEligibility is XYApprovable {

  // Stores a mapping of wallet eligibility state
  // The address can be whatever the caller wants
  // 0 = Not yet XYEligible
  // setting eligibility is permanent
  mapping(address => address) public eligible;

  function setEligiblity(address _wallet, address _proof) public onlyApprovers {
    require(eligible[_wallet] == 0);
    eligible[_wallet] = _proof;
  }

  modifier onlyEligible() {
    require(eligible[msg.sender] != 0);
    _;
  }

  modifier onlyIneligible() {
    require(eligible[msg.sender] == 0);
    _;
  }

}
