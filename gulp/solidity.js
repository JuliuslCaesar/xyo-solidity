/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Friday, March 16, 2018 8:46 AM
 * @Email:  developer@xyfindables.com
 * @Filename: solidity.js
 * @Last modified by:   arietrouw
 * @Last modified time: Sunday, March 18, 2018 11:34 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* eslint no-console: 0 */

const gulp = require(`gulp`);

const through = require(`through2`);
const Vinyl = require(`vinyl`);
const rename = require(`gulp-rename`);

const connect = require(`gulp-connect`);
const debug = require(`gulp-debug-streams`);

const XYSolidity = require(`./../index.js`);

const CONTRACT_BASE = `./contracts`;
const OUTPUT_BASE = `./dist`;

const getLocation = (base, location) => `${base}${location}`;

const xycompile = (path, callback) => {
  const solidity = new XYSolidity();
  solidity.contracts.load(path, callback);
};

const compile = through.obj((_file, encoding, callback) => {
  const file = _file;
  console.log(`gulpCompile: ${file.path}`);
  xycompile(file.path, (error, result) => {
    if (error) {
      for (let i = 0; i < error.length; i++) {
        console.log(error[i]);
      }
    }
    console.log(result.bytecode.length);
    const f = new Vinyl({
      contents: Buffer.from(JSON.stringify(result)), cwd: file.cwd, base: file.base, path: file.path,
    });
    console.log(JSON.stringify(result));
    callback(null, f);
  });
});

const solidity = () => gulp.src(getLocation(CONTRACT_BASE, `/**/*.sol`))
  .pipe(debug())
  .pipe(compile)
  .pipe(debug())
  .pipe(rename({ extname: `.json` }))
  .pipe(debug())
  .pipe(gulp.dest(getLocation(OUTPUT_BASE, `/contracts/`)));

gulp.task(`solidity-task`, solidity);

gulp.task(`solidity`, [`solidity-task`], () => {
  gulp.watch(getLocation(CONTRACT_BASE, `/**/*.*`), [`solidity`], connect.reload());
});

module.exports = solidity;
