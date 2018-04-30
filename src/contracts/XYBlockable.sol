pragma solidity ^0.4.19;

import "Ownable.sol";

contract XYBlockable is Ownable{

  // we need to block, but do not want to allow for future calls from a wallet, but keep the
  // previous wallet data address intact for our records
  // blocking is permanent
  mapping(address => bool) public blocked;

  function blockAddress(address _address) public onlyOwner {
    blocked[_address] = true;
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
