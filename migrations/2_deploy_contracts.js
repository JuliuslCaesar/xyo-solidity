/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 9:38 AM
 * @Email:  developer@xyfindables.com
 * @Filename: 2_deploy_contracts.js
 * @Last modified by:   arietrouw
 * @Last modified time: Sunday, March 18, 2018 3:40 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* global artifacts:true */
/* global web3:true */
/* eslint no-console:0 */
/* eslint no-shadow:0 */

console.log(`\r\n\r\n=============================`);
console.log(`========== Deploying ==========`);
console.log(`=============================\r\n\r\n`);

const Erc20 = artifacts.require(`ERC20`);
const XYOfficialTokenSale = artifacts.require(`XYOfficialTokenSale`);
const XYVariablePriceTest = artifacts.require(`XYVariablePriceTest`);

const tokensToCreate = 100000000000;

const minEther = 0.01;
const startEpoch = Date.parse(`20 Mar 2017 00:00:00 GMT`) / 1000;
const endEpoch = Date.parse(`21 May 2017 00:00:00 GMT`) / 1000;
const startPrice = web3.toWei(100000);
const endPrice = web3.toWei(33333);
const variableMax = 36000000000;
const fixedMax = 9000000000;


module.exports = function (deployer) {
  return deployer.deploy(
    Erc20,
    tokensToCreate,
    `Test`,
    `TST`,
  ).then(() => deployer.deploy(
    XYOfficialTokenSale,
    Erc20.address,
    minEther,
    startEpoch,
    endEpoch,
    startPrice,
    endPrice,
    variableMax,
    fixedMax,
  ).then(() => deployer.deploy(XYVariablePriceTest)));
};
