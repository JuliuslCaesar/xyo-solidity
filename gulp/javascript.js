/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Wednesday, March 14, 2018 8:44 AM
 * @Email:  developer@xyfindables.com
 * @Filename: browserify.js
 * @Last modified by:   arietrouw
 * @Last modified time: Monday, April 30, 2018 11:02 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

const babel = require(`gulp-babel`)
const gulp = require(`gulp`)

const jsToCommon = () => gulp.src(`./src/**/*.js`)
  .pipe(babel())
  .pipe(gulp.dest(`./dist`))

const javascript = () => jsToCommon()

gulp.task(`js_es6_to_common`, () => jsToCommon())

gulp.task(`js`, javascript)

gulp.task(`javascript`, javascript)

module.exports = javascript
