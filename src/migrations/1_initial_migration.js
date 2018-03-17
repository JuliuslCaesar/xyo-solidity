/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 9:43 AM
 * @Email:  developer@xyfindables.com
 * @Filename: 1_initial_migration.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, March 17, 2018 1:06 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* global artifacts:true */

const Migrations = artifacts.require(`./Migrations.sol`);

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
