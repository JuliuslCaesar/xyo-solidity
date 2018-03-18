/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 4:45 PM
 * @Email:  developer@xyfindables.com
 * @Filename: TokenSaleTest.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, March 17, 2018 11:40 PM
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

const ERC20 = artifacts.require(`ERC20`);
const XYOfficialTokenSale = artifacts.require(`XYOfficialTokenSale`);


contract(`XYOfficialTokenSale-ERC20`, (accounts) => {
  const accountZero = accounts[0];
  const accountOne = accounts[1];

  it(`should have 100000000000 XYO tokens for Account[0]`, () => {
    return ERC20.deployed()
      .then((erc20) => {
        return erc20.balanceOf(accountZero);
      })
      .then((value) => {
        return assert.equal(
          value.toNumber(),
          web3.toWei(100000000000),
          `Balance not correct [${value.toNumber()}]`,
        );
      });
  });

  it(`should make 100000000 XYO Tokens Available`, () => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return ERC20.deployed()
          .then((instance) => {
            const erc20 = instance;
            return erc20.approve(
              tokenSale.address,
              web3.toWei(10000000000), {
                from: accountZero,
              },
            ).then((result) => {
              assert(result);
              return erc20.allowance(accountZero, tokenSale.address)
                .then((allowance) => {
                  return assert.equal(
                    allowance.toNumber(),
                    web3.toWei(10000000000),
                    `Allowance not correct [${allowance}]`,
                  );
                });
            });
          });
      });
  });

  it(`should buy 0.1 Ether worth of XYO`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.purchase({ from: accountOne, value: web3.toWei(0.1) })
          .then((result) => {
            assert(result, `Purchase must return True`);
          });
      });
  }));

  it(`should have 0.1 Ether pending`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.pending(accountOne)
          .then((pending) => {
            return assert.equal(
              pending[0].toNumber(),
              web3.toWei(0.1),
              `Pending Ether not correct [${pending}]`,
            );
          });
      });
  }));

  it(`should have 1 Ether worth of XYO pending`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.pending(accountOne)
          .then((pending) => {
            return assert.equal(
              pending[1].toNumber(),
              web3.toWei(0.1 * 100000),
              `Pending XYO not correct [${pending}]`,
            );
          });
      });
  }));

  it(`should have 0.1 Ether balance`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        const balance = web3.eth.getBalance(tokenSale.address);
        return assert.equal(
          balance.toNumber(),
          web3.toWei(0.1),
          `Balance Ether not correct [${balance.toNumber()}]`,
        );
      });
  }));

  it(`should have 1 Ether worth of XYO balance`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return ERC20.deployed()
          .then((erc20) => {
            erc20.balanceOf.call(tokenSale.address)
              .then((balance) => {
                return assert.equal(
                  balance.toNumber(),
                  web3.toWei(0.1 * 100000),
                  `Pending XYO not correct [${balance}]`,
                );
              });
          });
      });
  }));

  it(`should approve pending transaction`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.approve(accountOne, accountOne)
          .then((result) => {
            assert(result, `Approve must return True [${result}]`);
          });
      });
  }));

  it(`should no longer have 0.1 Ether pending`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.pending(accountOne)
          .then((pending) => {
            return assert.equal(
              pending[0].toNumber(),
              web3.toWei(0),
              `Pending Ether not correct [${pending}]`,
            );
          });
      });
  }));

  it(`should no longer have 0.1 Ether worth of XYO pending`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.pending(accountOne)
          .then((pending) => {
            return assert.equal(
              pending[1].toNumber(),
              web3.toWei(0),
              `New Pending XYO not correct [${pending}]`,
            );
          });
      });
  }));

  it(`number sold should have gone up`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.numberSold()
          .then((numberSold) => {
            return assert(
              web3.fromWei(numberSold).toString() ===
              (0.1 * 100000).toString(),
              `Number Sold not correct [${web3.fromWei(numberSold)}, ${0.1 * 100000}]`,
            );
          });
      });
  }));

  it(`should have a new price`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.predictTokensForEther(web3.toWei(3))
          .then((tokens) => {
            return assert(
              tokens.toString(10) ===
              web3.toWei(1 * 100000).toString(10),
              `New Price not correct [${tokens.toString(10)}, ${web3.toWei(1 * 100000).toString(10)}]`,
            );
          });
      });
  }));
});
