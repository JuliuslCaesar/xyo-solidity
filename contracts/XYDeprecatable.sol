pragma solidity ^0.4.19;

import "./Ownable.sol";

contract XYDeprecatable is Ownable {

  address public deprecated = 0;

  modifier onlyIfNotDeprecated() {
    require(deprecated == 0);
    _;
  }

  function deprecate(address _newAddress) public onlyOwner {
    deprecated = _newAddress;
  }
}
