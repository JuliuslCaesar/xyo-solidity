/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Friday, March 16, 2018 8:46 AM
 * @Email:  developer@xyfindables.com
 * @Filename: solidity.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, May 19, 2018 11:29 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

const gulp = require(`gulp`)

const rename = require(`gulp-rename`)

const solc = require(`./plugins/solc.js`)

const solidity1 = () => gulp.src(`./src/contracts/**/*.sol`)
  .pipe(solc())
  .pipe(rename({ extname: `.json` }))
  .pipe(gulp.dest(`./dist/contracts/`))

const solidity2 = () => gulp.src(`./src/contracts/**/*.sol`)
  .pipe(solc({
    makeModule: true,
    mask: {
      assembly: false,
      bytecode: false,
      functionHashes: true,
      gasEstimates: true,
      interface: true,
      metaData: false,
      opcodes: false,
      runtimeBytecode: false,
      srcmap: false,
      srcmapRuntime: false
    }
  }))
  .pipe(rename({ extname: `.js` }))
  .pipe(gulp.dest(`./dist/contracts`))

gulp.task(`solidity1`, solidity1)

gulp.task(`solidity2`, solidity2)

gulp.task(`solidity`, gulp.parallel(`solidity1`, `solidity2`), () => {})

module.exports = solidity1
