pragma solidity ^0.4.19;

import "./Ownable.sol";

contract XYKillable is Ownable {
  bool public killed;

  // this marks the contract dead forever - no more transactions
  // flushes all ETH from the contract to the seller
  function kill() public onlyOwner onlyNotKilled {
    killed = true;
    owner.transfer(address(this).balance);
  }

  modifier onlyKilled() {
    require(killed);
    _;
  }

  modifier onlyNotKilled() {
    require(!killed);
    _;
  }
}
