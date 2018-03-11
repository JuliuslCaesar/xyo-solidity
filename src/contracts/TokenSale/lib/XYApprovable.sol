pragma solidity ^0.4.2;

import "./XYKillable.sol";

contract XYApprovable is XYKillable {

    mapping (address => bool) private approvers;

    function XYApprovable () public {
      approvers[msg.sender] = true;
    }

    function setApprover(address _approver, bool _enabled) public onlyOwner notKilled {
      approvers[_approver] = _enabled;
    }

    modifier onlyApprovers() {
        require(approvers[msg.sender]);
        _;
    }

}
