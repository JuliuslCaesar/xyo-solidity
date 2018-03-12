pragma solidity ^0.4.21;

import "./XYBlockable.sol";

contract XYProofOfEligibility is XYBlockable {

  // Stores a mapping of wallet eligibility state
  // The address can be whatever the caller wants
  // 0 = Not yet XYEligible
  // setting eligibility is permanent
  mapping(address => address) private eligible;

  function getEligiblity(address _wallet) public view returns (address) {
    return eligible[_wallet];
  }

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
