pragma solidity ^ 0.4 .2;

import "./XYPendingTokenSale.sol";


contract XYEligibleTokenSale is XYPendingTokenSale {


  // Stores a mapping of wallet eligibility state
  // The address can be whatever the caller wants
  // 0 = Not yet XYEligible
  // setting eligibility is permanent
  mapping(address => address) public eligible;

  // we use mapping for blocking since there may be a case where after eligibility passes
  // we need to block, but do not want to allow for future eligibility, and keep the
  // eligibility address in tact for our records
  // blocking is permanent
  mapping(address => bool) public blocked;

  function XYEligibleTokenSale(address _token, address _beneficiary, uint _price, uint _tokensAvailable, uint _minEther, uint _startTime, uint _endTime)
  public XYPendingTokenSale(_token, _beneficiary, _price, _tokensAvailable, _minEther, _startTime, _endTime) {}

  function approveWithEligibility(address _buyer, address _proofOfEligibility) public onlyApprovers {
    require(eligible[_buyer] == 0);
    require(!blocked[_buyer]);
    super.approve(_buyer);
    eligible[_buyer] = _proofOfEligibility;
  }

  //this should never be used, but it prevents a call-around
  function approve(address _buyer) public {
    require(eligible[_buyer] != 0);
    require(!blocked[_buyer]);
    super.approve(_buyer);
  }

  function _purchase() internal {
    address buyer = msg.sender;
    require(!blocked[buyer]);
    super._purchase();

    //if the buyer is eligible, auto approve
    if (eligible[buyer] != 0) {
      _approve(buyer);
    }
  }
}
