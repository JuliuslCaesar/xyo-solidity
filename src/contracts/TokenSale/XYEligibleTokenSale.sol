pragma solidity ^0.4.2;

import "./XYPendingTokenSale.sol";

contract XYEligibleTokenSale is XYPendingTokenSale {


    // Stores a mapping of wallet eligibility state
    mapping (address => bool) public eligible;

    function XYEligibleTokenSale (address _token, address _beneficiary, uint _price, uint _tokensAvailable, uint _minEther, uint _startTime, uint _endTime)
      XYPendingTokenSale(_token, _beneficiary, _price, _tokensAvailable, _minEther, _startTime, _endTime)
    public {
    }

    function approve(address _buyer) public onlyApprovers {
      super.approve(_buyer);
      eligible[_buyer] = true;
    }

    function _purchase() internal {
      address buyer = msg.sender;
      super._purchase();

      //if the buyer is eligible, auto approve
      if (eligible[buyer]) {
        _approve(buyer);
      }
    }
}
