/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 4:45 PM
 * @Email:  developer@xyfindables.com
 * @Filename: TokenSaleTest.js
 * @Last modified by:   arietrouw
 * @Last modified time: Sunday, March 18, 2018 6:03 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* global artifacts:true */
/* global contract:true */
/* global web3:true */
/* global assert:true */
/* eslint no-console:0 */
/* eslint no-shadow:0 */
/* eslint arrow-body-style:0 */

const XYVariablePriceTest = artifacts.require(`XYVariablePriceTest`);

const BN = (_x_) => {
  return web3.toBigNumber(_x_);
};

const FW = (_x_) => {
  return BN(web3.fromWei(BN(_x_)));
};

const TW = (_x_) => {
  return BN(web3.toWei(BN(_x_)));
};

const CMP = (_x_, _y_) => {
  return BN(_x_).eq(BN(_y_));
};

const startPrice = TW(100000);
const endPrice = TW(33333);
const variableMax = TW(36000000000);
const fixedMax = TW(9000000000);

const ethCheck = TW(100);
const numberSold = TW(BN(36000000000).times(99990).div(100000));

contract(`XYVariablePriceTest`, () => {
  it(`tokens for ${FW(ethCheck).toString(10)} ETH`, () => {
    return XYVariablePriceTest.deployed()
      .then((priceTest) => {
        return priceTest.getTokensForEther.call(
          numberSold,
          ethCheck,
          startPrice,
          endPrice,
          FW(variableMax),
          FW(fixedMax),
        )
          .then((predTokens) => {
            console.log(`tokens for first: ${FW(predTokens).toString(10)}`);
            return assert(
              CMP(FW(predTokens), FW(startPrice) * FW(ethCheck)),
              `Tokens not correct [Actual: ${FW(predTokens).toString(10)}:Expected: ${BN(FW(startPrice) * ethCheck).toString(10)}]`,
            );
          });
      });
  });

  it(`desired Variable Tokens for ${FW(ethCheck)} ETH`, () => {
    return XYVariablePriceTest.deployed()
      .then((priceTest) => {
        return priceTest.getDesiredVariableTokensForEther.call(
          numberSold,
          ethCheck,
          startPrice,
          endPrice,
          variableMax,
        )
          .then((predTokens) => {
            console.log(`desired variable: ${BN(predTokens).toString(10)}`);
            return assert(
              CMP(FW(predTokens), FW(startPrice) * FW(ethCheck)),
              `Tokens not correct [Actual: ${FW(predTokens).toString(10)}:Expected: ${BN(FW(startPrice) * ethCheck).toString(10)}]`,
            );
          });
      });
  });

  it(`max Variable Tokens for Transaction`, () => {
    return XYVariablePriceTest.deployed()
      .then((priceTest) => {
        return priceTest.getMaxVariableAvailableForTransaction.call(
          numberSold,
          variableMax,
        )
          .then((tokens) => {
            console.log(`max variable: ${FW(tokens).toString(10)}`);
            let expected = variableMax;
            if (numberSold > variableMax) {
              expected = 0;
            } else {
              expected = variableMax - numberSold;
            }
            return assert(
              CMP(FW(tokens), FW(expected)),
              `Tokens not correct [Actual: ${FW(tokens).toString(10)}:Expected: ${FW(expected).toString(10)}]`,
            );
          });
      });
  });

  it(`remaining Fixed`, () => {
    return XYVariablePriceTest.deployed()
      .then((priceTest) => {
        return priceTest.getRemainingFixed.call(
          numberSold,
          variableMax,
          fixedMax,
        )
          .then((tokens) => {
            console.log(`remaining fixed: ${FW(tokens).toString(10)}`);
            return assert(
              CMP(FW(tokens), FW(fixedMax)),
              `Tokens not correct [Actual: ${FW(tokens).toString(10)}:Expected: ${FW(variableMax).toString(10)}]`,
            );
          });
      });
  });

  it(`max ether spendable on Fixed`, () => {
    return XYVariablePriceTest.deployed()
      .then((priceTest) => {
        return priceTest.getMaxEtherSpendableOnFixed.call(
          numberSold,
          endPrice,
          variableMax,
          fixedMax,
        )
          .then((eth) => {
            console.log(`max eth on fixed: ${FW(eth).toString(10)}`);
            return assert(
              CMP(BN(eth), BN(fixedMax).div(FW(endPrice))),
              `Tokens not correct [Actual: ${FW(eth).toString(10)}:Expected: ${FW(BN(fixedMax).div(FW(endPrice)).toString(10))}]`,
            );
          });
      });
  });

  it(`max ether spendable on Variable`, () => {
    return XYVariablePriceTest.deployed()
      .then((priceTest) => {
        return priceTest.getMaxEtherSpendableOnVariable.call(
          numberSold,
          startPrice,
          endPrice,
          variableMax,
        )
          .then((eth) => {
            let expectedPrice = endPrice;
            if (numberSold.lt(variableMax)) {
              const priceDelta = FW(startPrice).sub(FW(endPrice));
              console.log(`Price Delta: ${priceDelta.toString(10)}`);
              const percentComplete = numberSold.div(FW(variableMax));
              console.log(`Percent Complete: ${percentComplete.toString(10)}`);
              expectedPrice = FW(startPrice)
                .sub(percentComplete.shift(-9).times(priceDelta).shift(-9));
            }

            let remaining = variableMax;
            if (numberSold > variableMax) {
              remaining = 0;
            } else {
              remaining = variableMax - numberSold;
            }
            console.log(`max eth on variable: ${FW(eth).toString(10)}`);
            const expectedMaxEth = BN(remaining).div(expectedPrice);
            return assert(
              CMP(BN(eth), BN(variableMax).div(FW(expectedMaxEth))),
              `Eth not correct [Actual: ${FW(eth).toString(10)}:Expected: ${FW(expectedMaxEth).toString(10)}]`,
            );
          });
      });
  });

  it(`current Price in Tokens for ${BN(ethCheck).toString()} ETH`, () => {
    return XYVariablePriceTest.deployed()
      .then((priceTest) => {
        return priceTest.getCurrentPrice.call(
          numberSold,
          startPrice,
          endPrice,
          variableMax,
        )
          .then((currentPrice) => {
            console.log(`current Price (tkn/eth): ${FW(currentPrice).toString(10)}`);
            let expectedPrice = endPrice;
            if (numberSold.lt(variableMax)) {
              const priceDelta = FW(startPrice).sub(FW(endPrice));
              console.log(`Price Delta: ${priceDelta.toString(10)}`);
              const percentComplete = numberSold.div(FW(variableMax));
              console.log(`Percent Complete: ${percentComplete.toString(10)}`);
              expectedPrice = FW(startPrice)
                .sub(percentComplete.shift(-9).times(priceDelta).shift(-9));
            }
            return assert(
              CMP(FW(currentPrice), expectedPrice),
              `Tokens not correct [Actual: ${FW(currentPrice).toString(10)}:Expected: ${expectedPrice.toString(10)}]`,
            );
          });
      });
  });
});
