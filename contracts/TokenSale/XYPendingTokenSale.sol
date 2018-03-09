pragma solidity ^0.4.2;

import "./XYTimedTokenSale.sol";

contract XYPendingTokenSale is XYTimedTokenSale {

    struct Pending {
      uint eth;
      uint tokens;
    }

    mapping (address => Pending) public pending;
    mapping (address => bool) public approvers;

    function XYPendingTokenSale (address _token, address _beneficiary, uint _price, uint _tokensAvailable, uint _minEther, uint _startTime, uint _endTime)
      XYTimedTokenSale(_token, _beneficiary, _price, _tokensAvailable, _minEther, _startTime, _endTime)
    public {
      approvers[seller] = true;
    }

    //we store the pending eth in the contract
    function _acceptEther(uint _amount) internal {
      if (this.send(_amount)) {
        AcceptEther(this, msg.sender, _amount);
      } else {
        revert();
      }
    }

    //we store the pending tokens in the contracts
    function _sendTokens(uint _amount) internal {
      token.transferFrom(seller, this, _amount);
    }

    function setApprover(address _approver, bool _enabled) public onlySeller {
      approvers[_approver] = _enabled;
    }

    function approve(address _buyer) public onlyApprovers {
      _approve(_buyer);
    }

    function _approve(address _buyer) internal {
      if (pending[_buyer].tokens > 0) {
        if (seller.send(pending[_buyer].eth)) {
          token.transferFrom(this, _buyer, pending[_buyer].tokens);
          pending[_buyer].tokens = 0;
          pending[_buyer].eth = 0;
        } else {
          revert();
        }
      }
    }

    modifier onlyApprovers() {
        require(approvers[msg.sender]);
        _;
    }

}
