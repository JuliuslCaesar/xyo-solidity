/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Friday, March 9, 2018 4:41 PM
 * @Email:  developer@xyfindables.com
 * @Filename: gulpfile.js
 * @Last modified by:   arietrouw
 * @Last modified time: Monday, April 30, 2018 11:03 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

const gulp = require(`gulp`)
const sequence = require(`run-sequence`)

require(`./gulp/clean.js`)
require(`./gulp/help.js`)
require(`./gulp/javascript.js`)
require(`./gulp/solidity.js`)

gulp.task(`default`, [`help`])

gulp.task(`build`, callback => sequence(`solidity`, `js`, callback))
