/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 9:38 AM
 * @Email:  developer@xyfindables.com
 * @Filename: 2_deploy_contracts.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, March 17, 2018 9:19 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* global artifacts:true */
/* eslint no-console:0 */
/* eslint no-shadow:0 */

console.log(`\r\n\r\n=============================`);
console.log(`========== Deploying ==========`);
console.log(`=============================\r\n\r\n`);

const Erc20 = artifacts.require(`ERC20`);
const XYOfficialTokenSale = artifacts.require(`XYOfficialTokenSale`);

module.exports = function (deployer) {
  return deployer.deploy(
    Erc20,
    100000000000,
    `Test`,
    `TST`,
  ).then(() => deployer.deploy(
    XYOfficialTokenSale,
    Erc20.address,
    `0.01`,
    Date.parse(`20 Mar 2017 00:00:00 GMT`) / 1000,
    Date.parse(`21 May 2018 00:00:00 GMT`) / 1000,
    `100000000000000000000000`,
    `33333333333333333333333`,
    `36000000000`,
    `9000000000`,
  ));
};
