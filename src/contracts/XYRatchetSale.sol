pragma solidity ^0.4.19;

import "./XYTokenSale.sol";

contract XYRatchetSale is XYTokenSale {

  uint private stepSize;
  uint private priceIncrease;
  uint private totalSold;

  constructor(address _token, address _beneficiary, uint _price, uint _minEther, uint _stepSize, uint _priceIncrease)
  public XYTokenSale(_token, _beneficiary, _price, _minEther) {
    stepSize = _stepSize;
    priceIncrease = _priceIncrease;
  }

  function _purchase(uint _ethAmount, uint _tokenAmount) internal onlyNotKilled {
    super._purchase(_ethAmount, _tokenAmount);
    totalSold = totalSold + _tokenAmount;
  }

  function getStartingPrice() public view onlyNotKilled returns(uint) {
    return super.getPrice();
  }

  function getPrice() public view onlyNotKilled returns(uint) {
    return SafeMath.sub(super.getPrice(), getCompletedSteps() * priceIncrease);
  }

  function getCompletedSteps() public view onlyNotKilled returns(uint) {
    return SafeMath.div(totalSold, stepSize);
  }

}
