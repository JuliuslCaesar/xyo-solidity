pragma solidity ^0.4.2;

import "./Ownable.sol";

contract XYKillable is Ownable {
  bool private isKilled;

  // this marks the contract dead forever - no more transactions
  // flushes all ETH from the contract to the seller
  function kill() public onlyOwner notKilled {
    isKilled = true;
    owner.transfer(this.balance);
  }

  modifier killed() {
    require(isKilled);
    _;
  }

  modifier notKilled() {
    require(!isKilled);
    _;
  }
}
