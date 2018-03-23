/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Friday, March 9, 2018 4:41 PM
 * @Email:  developer@xyfindables.com
 * @Filename: gulpfile.js
 * @Last modified by:   arietrouw
 * @Last modified time: Friday, March 23, 2018 12:33 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* eslint global-require:0 */

const gulp = require(`gulp`);

require(`./gulp/clean.js`);
require(`./gulp/solidity.js`);

gulp.task(`default`, [`solidity`]);
