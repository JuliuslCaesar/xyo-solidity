pragma solidity ^0.4.19;

import "XYTimedTokenSale.sol";
import "XYBlockable.sol";
import "XYApprovable.sol";

contract XYPendingTokenSale is XYTimedTokenSale, XYApprovable, XYBlockable {

    struct Pending {
      uint eth;
      uint tokens;
    }

    event Approved(address buyer);

    mapping (address => Pending) public pending;

    constructor (address _token, address _beneficiary, uint _price, uint _minEther, uint _startTime, uint _endTime)
      XYTimedTokenSale(_token, _beneficiary, _price, _minEther, _startTime, _endTime)
    public {
    }

    function approve(address _buyer) public onlyApprovers {
      _approve(_buyer);
      emit Approved(_buyer);
    }

    //we store the pending eth in the contract
    function _acceptEther(uint _amount) internal {
      pending[msg.sender].eth = pending[msg.sender].eth + _amount;
      emit EtherAccepted(this, msg.sender, _amount);
    }

    //we store the pending tokens in the contracts
    function _sendTokens(uint _amount) internal {
      pending[msg.sender].tokens = pending[msg.sender].tokens + _amount;
      token.transferFrom(owner, beneficiary, _amount);
      token.transferFrom(owner, this, _amount);
    }

    //broke this out so that we can call it internally for auto-approve
    function _approve(address _buyer) internal {
      if (pending[_buyer].tokens > 0) {
        beneficiary.transfer(pending[_buyer].eth);
        token.transfer(_buyer, pending[_buyer].tokens);
        pending[_buyer].tokens = 0;
        pending[_buyer].eth = 0;
      }
    }

}
