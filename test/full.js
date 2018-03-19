/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 4:45 PM
 * @Email:  developer@xyfindables.com
 * @Filename: TokenSaleTest.js
 * @Last modified by:   arietrouw
 * @Last modified time: Sunday, March 18, 2018 7:05 PM
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

const etherToBuyWith = 2;
const tokensCreated = 100000000000;
const tokensToMakeAvailable = 90000000000;
const startPrice = 100000;
// const endPrice = 33333;
// const variableMax = 36000000000;
// const fixedMax = 9000000000;

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

contract(`XYOfficialTokenSale-ERC20`, (accounts) => {
  const accountZero = accounts[0];
  const accountOne = accounts[1];
  const accountNine = accounts[9];

  it(`should have 100000000000 XYO tokens for Account[0]`, () => {
    return ERC20.deployed()
      .then((erc20) => {
        return erc20.balanceOf(accountZero);
      })
      .then((balance) => {
        return assert.equal(
          FW(balance).toString(10),
          BN(tokensCreated).toString(10),
          `Balance not correct [${BN(balance).toString(10)}]`,
        );
      });
  });

  it(`should make ${tokensToMakeAvailable} XYO Tokens Available`, () => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return ERC20.deployed()
          .then((instance) => {
            const erc20 = instance;
            return erc20.approve(
              tokenSale.address,
              TW(tokensToMakeAvailable), {
                from: accountZero,
              },
            ).then((result) => {
              assert(result);
              return erc20.allowance(accountZero, tokenSale.address)
                .then((allowance) => {
                  return assert.equal(
                    allowance.toNumber(),
                    TW(tokensToMakeAvailable),
                    `Allowance not correct [${allowance}]`,
                  );
                });
            });
          });
      });
  });

  it(`${etherToBuyWith} Ether should buy ${etherToBuyWith * startPrice} XYO`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.predictTokensForEther.call(TW(etherToBuyWith))
          .then((tokens) => {
            return assert(
              CMP(FW(tokens), startPrice * etherToBuyWith),
              `Projected Price Wrong [${tokens}:${startPrice * etherToBuyWith}]`,
            );
          });
      });
  }));

  it(`should buy ${etherToBuyWith} Ether worth of XYO`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.purchase({ from: accountOne, value: TW(etherToBuyWith) })
          .then((result) => {
            assert(result, `Purchase must return True`);
          });
      });
  }));

  it(`should have ${etherToBuyWith} Ether pending`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.pending(accountOne)
          .then((pending) => {
            return assert(
              CMP(pending[0], TW(etherToBuyWith)),
              `Pending Ether not correct [${BN(pending[0])}:${TW(etherToBuyWith)}]`,
            );
          });
      });
  }));

  it(`should have ${etherToBuyWith} Ether worth of XYO pending`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.pending(accountOne)
          .then((pending) => {
            return assert(
              CMP(pending[1], TW(etherToBuyWith * startPrice)),
              `Pending XYO not correct [${BN(pending[1]).toString(10)}]`,
            );
          });
      });
  }));

  it(`should have ${etherToBuyWith} Ether balance`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        const balance = web3.eth.getBalance(tokenSale.address);
        return assert(
          CMP(balance, TW(etherToBuyWith)),
          `Balance Ether not correct [${BN(balance).toString(10)}:${TW(etherToBuyWith).toString(10)}]`,
        );
      });
  }));

  it(`should have ${etherToBuyWith} Ether worth of XYO balance`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return ERC20.deployed()
          .then((erc20) => {
            return erc20.balanceOf.call(tokenSale.address)
              .then((balance) => {
                return assert(
                  CMP(balance, TW(etherToBuyWith * startPrice)),
                  `Pending XYO not correct [${BN(balance).toString(10)}:${TW(etherToBuyWith * startPrice).toString(10)}]`,
                );
              });
          });
      });
  }));

  it(`should have ${etherToBuyWith} Ether worth of XYO balance [AccountNine]`, (() => {
    return ERC20.deployed()
      .then((erc20) => {
        return erc20.balanceOf.call(accountNine)
          .then((balance) => {
            return assert(
              CMP(balance, TW(etherToBuyWith * startPrice)),
              `Pending XYO not correct [${BN(balance).toString(10)}:${TW(etherToBuyWith * startPrice).toString(10)}]`,
            );
          });
      });
  }));

  it(`should approve pending transaction`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.approve(accountOne, [`0x33`, `0x34`, `0x35`, `0x37`])
          .then((result) => {
            return assert(result, `Approve must return True [${result}]`);
          });
      });
  }));

  it(`should have proof of eligibility`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.eligible(accountOne, 1)
          .then((eligByte) => {
            return assert(eligByte === `0x34`, `Elig Bytes must be 4 [${eligByte}]`);
          });
      });
  }));

  it(`should no longer have ${etherToBuyWith} Ether pending`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.pending(accountOne)
          .then((pending) => {
            return assert(
              CMP(pending[0], TW(0)),
              `Pending Ether not correct [${BN(pending[0]).toString(10)}:${TW(0).toString(10)}]`,
            );
          });
      });
  }));

  it(`should have ${etherToBuyWith} Ether balance (Account Nine)`, (() => {
    const balance = web3.eth.getBalance(accountNine);
    return assert(
      CMP(balance, TW(etherToBuyWith)),
      `Balance Ether not correct [${FW(balance).toString(10)}:${BN(etherToBuyWith).toString(10)}]`,
    );
  }));

  it(`should no longer have ${etherToBuyWith} Ether worth of XYO pending`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.pending(accountOne)
          .then((pending) => {
            return assert(
              CMP(pending[1], TW(0)),
              `New Pending XYO not correct [${BN(pending[1]).toString(10)}:${TW(0)}]`,
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
              CMP(FW(numberSold), etherToBuyWith * startPrice),
              `Number Sold not correct [Actual: ${FW(numberSold).toString(10)}, Expected: ${BN(etherToBuyWith * startPrice).toString(10)}]`,
            );
          });
      });
  }));

  it(`should have a new price`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((tokenSale) => {
        return tokenSale.predictTokensForEther(TW(1))
          .then((tokens) => {
            return assert(
              tokens.toString(10) ===
              TW(etherToBuyWith * startPrice).toString(10),
              `New Price not correct [Actual: ${tokens.toString(10)}, Expected: ${TW(1 * startPrice).toString(10)}]`,
            );
          });
      });
  }));
});
