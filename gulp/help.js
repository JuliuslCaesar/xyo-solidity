/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, March 24, 2018 11:20 AM
 * @Email:  developer@xyfindables.com
 * @Filename: help.js
 * @Last modified by:   arietrouw
 * @Last modified time: Monday, April 30, 2018 10:56 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* eslint no-console: 0 */

const gulp = require(`gulp`)

const help = () => {
  console.log(`\r\n`)
  console.log(`\r\n`)
  console.log(`============================== XYO Gulp Help ==============================`)
  console.log(`\r\n`)
  console.log(` build        Start a standard build [build, build-debug, build-release]`)
  console.log(` clean        Delete the dist folder`)
  console.log(` contracts    Copy compiled solidity contracts from xyo-solidity to dist`)
  console.log(` help         Instructions on how to use XYO's Build System (this output)`)
  console.log(` javascript   Process .js files from src to dist`)
  console.log(`\r\n`)
  console.log(`\r\n`)
}

gulp.task(`help`, help)

module.exports = help
