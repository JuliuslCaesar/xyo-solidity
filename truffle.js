/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 17, 2018 9:43 AM
 * @Email:  developer@xyfindables.com
 * @Filename: truffle-config.js
 * @Last modified by:   arietrouw
 * @Last modified time: Sunday, March 18, 2018 1:15 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

// See <http://truffleframework.com/docs/advanced/configuration>
// to customize your Truffle configuration!

module.exports = {
  contracts_build_directory: `./dist/contracts`,
  networks: {
    development: {
      host: `127.0.0.1`,
      port: 9545,
      network_id: `*`, // Match any network id
    },
    ganache: {
      host: `127.0.0.1`,
      port: 8546,
      network_id: `*`, // Match any network id
    },
  },
};
