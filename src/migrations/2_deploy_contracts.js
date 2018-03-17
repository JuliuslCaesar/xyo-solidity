/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 9:38 AM
 * @Email:  developer@xyfindables.com
 * @Filename: 2_deploy_contracts.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, March 17, 2018 3:22 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* global artifacts:true */
/* global web3:true */
/* eslint no-console:0 */
/* eslint no-shadow:0 */

const toUTCDate = (epoch) => {
  const date = new Date(0);
  date.setUTCSeconds(epoch);
  return date;
};

console.log(`\r\n\r\n=============================`);
console.log(`========== Running ==========`);
console.log(`=============================\r\n\r\n`);

const Erc20 = artifacts.require(`ERC20`);
const XYOfficialTokenSale = artifacts.require(`XYOfficialTokenSale`);

const dumpXYTokenSale = (instance, next) => instance.then((contract) => {
  console.log(`\r\n========== Dump: XYTokenSale ==========\r\n`);
  return contract.token.call();
}).then((token) => {
  console.log(`Token: ${token}`);
  return instance;
}).then(salesContract => salesContract.getAvailableTokens.call())
  .then((availableTokens) => {
    console.log(`Available Tokens: ${availableTokens}`);
    return instance;
  })
  .then(contract => contract.minEther.call())
  .then((minEther) => {
    console.log(`Minimum Ether: ${minEther}`);
    return instance;
  })
  .then(contract => contract.getPrice.call())
  .then((price) => {
    console.log(`Price: ${price.toNumber()}`);
    if (next) {
      return next(instance);
    }
    return instance;
  });

const dumpXYTimedTokenSale = (instance, next) => instance.then((contract) => {
  console.log(`\r\n========== Dump: XYTimedTokenSale ==========\r\n`);
  return contract.startTime.call();
})
  .then((startTime) => {
    console.log(`startTime: ${toUTCDate(startTime.toNumber())}`);
    return instance;
  })
  .then(contract => contract.endTime.call())
  .then((endTime) => {
    console.log(`endTime: ${toUTCDate(endTime.toNumber())}`);
    return instance;
  })
  .then(contract => contract.isLive.call())
  .then((isLive) => {
    console.log(`isLive: ${isLive}`);
    if (next) {
      return next(instance);
    }
    return instance;
  });

const logPendingAddress = (instance, pendingAddresses, index, next) => {
  instance.then(contract => contract.pending.call(pendingAddresses[index]))
    .then((pending) => {
      console.log(`pending[${pendingAddresses[index]}]: ${pending}`);
      const newIndex = index + 1;
      if (newIndex >= pendingAddresses.length) {
        if (next) {
          return next(instance);
        }
        return instance;
      }
      return logPendingAddress(instance, pendingAddresses, newIndex, next);
    });
};

const dumpXYPendingTokenSale = (instance, pendingAddresses, next) => {
  console.log(`\r\n========== Dump: XYPendingTokenSale: ==========\r\n`);
  return logPendingAddress(instance, pendingAddresses, 0, next);
};

const dumpXYOfficialTokenSale = (instance, next) => instance.then((contract) => {
  console.log(`\r\n========== Dump: XYOfficialTokenSale ==========\r\n`);
  return contract.numberSold.call();
})
  .then((numberSold) => {
    console.log(`numberSold: ${numberSold.toString(10)}`);
    return instance;
  })
  .then(contract => contract.startPrice.call())
  .then((startPrice) => {
    console.log(`startPrice: ${startPrice.toString(10)}`);
    return instance;
  })
  .then(contract => contract.endPrice.call())
  .then((endPrice) => {
    console.log(`endPrice: ${endPrice.toString(10)}`);
    return instance;
  })
  .then(contract => contract.totalVariableTokens.call())
  .then((totalVariableTokens) => {
    console.log(`totalVariableTokens: ${totalVariableTokens.toString(10)}`);
    return instance;
  })
  .then(contract => contract.totalFixedTokens.call())
  .then((totalFixedTokens) => {
    console.log(`totalFixedTokens: ${totalFixedTokens.toString(10)}`);
    return instance;
  })
  .then(contract => contract.predictTokensForEther.call(web3.toWei(10)))
  .then((predictTokensForEther) => {
    console.log(`predictTokensForEther (10 ETH): ${web3.fromWei(predictTokensForEther).toString(10)}`);
    if (next) {
      return next(instance);
    }
    return instance;
  });

module.exports = function (deployer) {
  deployer.deploy(
    Erc20,
    1000000000000000000000,
    `Test`,
    `TST`,
  ).then(() => {
    const pendingAddresses = [];
    Erc20.deployed().then((token) => {
      pendingAddresses.push(token.address);
      deployer.deploy(
        XYOfficialTokenSale,
        token.address,
        `0.01`,
        Date.parse(`20 Mar 2018 00:00:00 GMT`) / 1000,
        Date.parse(`21 May 2018 00:00:00 GMT`) / 1000,
        `100000000000000000000000`,
        `33333333333333333333333`,
        `36000000000`,
        `9000000000`,
      ).then(() => {
        dumpXYTokenSale(XYOfficialTokenSale.deployed(), (instance) => {
          dumpXYTimedTokenSale(instance, (instance) => {
            dumpXYPendingTokenSale(instance, pendingAddresses, (instance) => {
              dumpXYOfficialTokenSale(instance);
            });
          });
        });
      });
    });
  });
};
