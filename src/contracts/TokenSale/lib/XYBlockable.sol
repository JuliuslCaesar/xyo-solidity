pragma solidity ^0.4.21;

import "./XYApprovable.sol";

contract XYBlockable is XYApprovable {

  // we need to block, but do not want to allow for future calls from a wallet, but keep the
  // previous wallet data address intact for our records
  // blocking is permanent
  mapping(address => bool) private blocked;

  function XYBlockable() public {
    setApprover(msg.sender, true);
  }

  function blockAddress(address _address) public onlyOwner notKilled {
    blocked[_address] = true;
  }

  function isBlocked(address _address) public view returns(bool) {
    return blocked[_address];
  }

  modifier onlyNotBlocked() {
    require(!blocked[msg.sender]);
    _;
  }

  modifier onlyBlocked() {
    require(blocked[msg.sender]);
    _;
  }

}
