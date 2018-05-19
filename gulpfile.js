/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Friday, March 9, 2018 4:41 PM
 * @Email:  developer@xyfindables.com
 * @Filename: gulpfile.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, May 19, 2018 11:31 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

const gulp = require(`gulp`)

require(`./gulp/clean.js`)
require(`./gulp/help.js`)
require(`./gulp/javascript.js`)
require(`./gulp/solidity.js`)

gulp.task(`default`, gulp.series(`help`), () => {})

gulp.task(`build`, gulp.series(`solidity`, `js`), () => {})
