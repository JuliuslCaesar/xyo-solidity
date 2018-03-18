/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 5:15 PM
 * @Email:  developer@xyfindables.com
 * @Filename: DumpContract.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, March 17, 2018 5:18 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* global artifacts:true */
/* global contract:true */
/* global web3:true */
/* eslint no-console:0 */
/* eslint no-shadow:0 */

const XYOfficialTokenSale = artifacts.require(`XYOfficialTokenSale`);

console.log(`\r\n\r\n=============================`);
console.log(`========== Dumping ==========`);
console.log(`=============================\r\n\r\n`);

const toUTCDate = (epoch) => {
  const date = new Date(0);
  date.setUTCSeconds(epoch);
  return date;
};

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
    console.log(`Price: ${web3.fromWei(price).toNumber()}`);
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

const dumpXYKillable = (instance, next) => instance.then((contract) => {
  console.log(`\r\n========== Dump: XYKillable ==========\r\n`);
  return contract.killed.call();
})
  .then((killed) => {
    console.log(`killed: ${killed}`);
    if (next) {
      return next(instance);
    }
    return instance;
  });

const dumpOwnable = (instance, next) => instance.then((contract) => {
  console.log(`\r\n========== Dump: Ownable ==========\r\n`);
  return contract.owner.call();
})
  .then((owner) => {
    console.log(`owner: ${owner}`);
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

const logApproverAddress = (instance, approverAddresses, index, next) => {
  instance.then(contract => contract.approvers.call(approverAddresses[index]))
    .then((approver) => {
      console.log(`approver[${approverAddresses[index]}]: ${approver}`);
      const newIndex = index + 1;
      if (newIndex >= approverAddresses.length) {
        if (next) {
          return next(instance);
        }
        return instance;
      }
      return logApproverAddress(instance, approverAddresses, newIndex, next);
    });
};

const dumpXYApprovable = (instance, approverAddresses, next) => {
  console.log(`\r\n========== Dump: XYApprovable: ==========\r\n`);
  return logApproverAddress(instance, approverAddresses, 0, next);
};

const logBlockedAddress = (instance, blockedAddresses, index, next) => {
  instance.then(contract => contract.blocked.call(blockedAddresses[index]))
    .then((blocked) => {
      console.log(`blocked[${blockedAddresses[index]}]: ${blocked}`);
      const newIndex = index + 1;
      if (newIndex >= blockedAddresses.length) {
        if (next) {
          return next(instance);
        }
        return instance;
      }
      return logApproverAddress(instance, blockedAddresses, newIndex, next);
    });
};

const dumpXYBlockable = (instance, blockedAddresses, next) => {
  console.log(`\r\n========== Dump: XYBlockable: ==========\r\n`);
  return logBlockedAddress(instance, blockedAddresses, 0, next);
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

contract(`XYOfficialTokenSale`, (accounts) => {
  const pendingAddresses = [];
  const approverAddresses = [];
  const blockedAddresses = [];
  pendingAddresses.push(accounts[0]);
  approverAddresses.push(accounts[0]);
  blockedAddresses.push(accounts[0]);
  dumpXYTokenSale(XYOfficialTokenSale.deployed(), (instance) => {
    dumpXYTimedTokenSale(instance, (instance) => {
      dumpXYPendingTokenSale(instance, pendingAddresses, (instance) => {
        dumpXYApprovable(instance, approverAddresses, (instance) => {
          dumpXYBlockable(instance, blockedAddresses, (instance) => {
            dumpXYKillable(instance, (instance) => {
              dumpOwnable(instance, (instance) => {
                dumpXYOfficialTokenSale(instance);
              });
            });
          });
        });
      });
    });
  });
});
