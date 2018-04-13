/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Monday, March 26, 2018 8:35 AM
 * @Email:  developer@xyfindables.com
 * @Filename: uncalibratedquery.js
 * @Last modified by:   arietrouw
 * @Last modified time: Monday, March 26, 2018 2:28 PM
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

const XYUncalibratedQuery = artifacts.require(`XYUncalibratedQuery`);
const XYUncalibratedQueryExample = artifacts.require(`XYUncalibratedQueryExample`);

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

const now = Math.floor((new Date()).getTime() / 1000);

const xyoAddress = `0x5aeda56215b167893e80b4fe645ba6d5bab767de`;

contract(`XYUncalibratedQuery`, (accounts) => {
  it(`should publish a query`, () => {
    return XYUncalibratedQuery.deployed()
      .then((query) => {
        return XYUncalibratedQueryExample.deployed()
          .then((example) => {
            return query.publishQuery.call(
              TW(100),
              xyoAddress,
              TW(1),
              TW(1),
              TW(5),
              now,
              example.address,
              { value: TW(1) },
            ).then((_index) => {
              return query.publishQuery.call(
                _xyoAddress,
                _index,
                int _latitude,
                int _longitude,
                int _altitude,
                uint _accuracy,
                uint _certainty,
                uint _epoch
              ).then((result2) => {
                return assert(result2);
              });
            });
          });
      });
  });
});
