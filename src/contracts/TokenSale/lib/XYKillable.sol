pragma solidity ^0.4.21;

import "./Ownable.sol";

contract XYKillable is Ownable {
  bool private _isKilled;

  // this marks the contract dead forever - no more transactions
  // flushes all ETH from the contract to the seller
  function kill() public onlyOwner notKilled {
    _isKilled = true;
    owner.transfer(address(this).balance);
  }

  function isKilled() public view returns (bool) {
    return _isKilled;
  }

  modifier killed() {
    require(_isKilled);
    _;
  }

  modifier notKilled() {
    require(!_isKilled);
    _;
  }
}
