/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Wednesday, February 28, 2018 12:49 PM
 * @Email:  developer@xyfindables.com
 * @Filename: index.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, March 10, 2018 9:39 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

const ncp = require(`ncp`).ncp;
const path = require(`path`);

const appDir = path.dirname(require.main.filename);

console.log(`Copying...[${appDir}]`);

ncp.limit = 16;

ncp(`${appDir}/dist/`, `${appDir}/../../dist`, (err) => {
  if (err) {
    return console.error(err);
  }
  console.log(`done!`);
});
