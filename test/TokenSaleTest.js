/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 4:45 PM
 * @Email:  developer@xyfindables.com
 * @Filename: TokenSaleTest.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, March 17, 2018 9:32 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* global artifacts:true */
/* global contract:true */
/* global web3:true */
/* eslint no-console:0 */
/* eslint no-shadow:0 */
/* eslint arrow-body-style:0 */

const XYOfficialTokenSale = artifacts.require(`XYOfficialTokenSale`);

contract(`XYOfficialTokenSale`, (accounts) => {
  it(`should buy 10 Ether worth of XYO`, (() => {
    return XYOfficialTokenSale.deployed()
      .then((instance) => {
        return instance.purchase({ from: accounts[0], value: web3.toWei(10) })
          .then((result) => {
            console.log(`Complete: ${JSON.stringify(result)}`);
          });
      });
  }));
});
