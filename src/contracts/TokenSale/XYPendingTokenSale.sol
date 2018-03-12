pragma solidity ^0.4.21;

import "./XYTimedTokenSale.sol";
import "./lib/XYApprovable.sol";

contract XYPendingTokenSale is XYTimedTokenSale, XYApprovable {

    struct Pending {
      uint eth;
      uint tokens;
    }

    mapping (address => Pending) public pending;

    function XYPendingTokenSale (address _token, uint _price, uint _minEther, uint _startTime, uint _endTime)
      XYTimedTokenSale(_token, _price, _minEther, _startTime, _endTime)
    public {
    }

    function approve(address _buyer) public onlyApprovers {
      _approve(_buyer);
    }

    //we store the pending eth in the contract
    function _acceptEther(uint _amount) internal {
      if (address(this).send(_amount)) {
        emit EtherAccepted(this, msg.sender, _amount);
      } else {
        revert();
      }
    }

    //we store the pending tokens in the contracts
    function _storeTokens(uint _amount) internal {
      token.transferFrom(owner, this, _amount);
    }

    //broke this out so that we can call it internally for auto-approve
    function _approve(address _buyer) internal {
      if (pending[_buyer].tokens > 0) {
        if (owner.send(pending[_buyer].eth)) {
          token.transferFrom(this, _buyer, pending[_buyer].tokens);
          pending[_buyer].tokens = 0;
          pending[_buyer].eth = 0;
        } else {
          revert();
        }
      }
    }

}
