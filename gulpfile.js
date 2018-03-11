/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Friday, March 9, 2018 4:41 PM
 * @Email:  developer@xyfindables.com
 * @Filename: gulpfile.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, March 10, 2018 6:06 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* eslint global-require:0 */

const gulp = require(`gulp`);
const through = require(`through2`);
const Vinyl = require(`vinyl`);
const rename = require(`gulp-rename`);
const XYSolidity = require(`./src/index.js`);

const SOURCE_BASE = `./src`;
const OUTPUT_BASE = `./dist`;

const getLocation = (base, location) => `${base}${location}`;

const compile = (path) => {
  const solidity = new XYSolidity();
  const result = solidity.contracts.load(path);
  return JSON.stringify(result);
};

const gulpCompile = through.obj((_file, encoding, callback) => {
  const file = _file;
  console.log(`gulpCompile: ${file.path}`);
  const result = compile(file.path, file.stem);
  const f = new Vinyl({
    contents: Buffer.from(result), cwd: file.cwd, base: file.base, path: file.path,
  });
  callback(null, f);
});

gulp.task(`solc`, () => {
  gulp.src(getLocation(SOURCE_BASE, `/contracts/**/*.sol`))
    .pipe(gulpCompile)
    .pipe(rename({ extname: `.json` }))
    .pipe(gulp.dest(getLocation(OUTPUT_BASE, `/contracts/`)));
});

gulp.task(`default`, [`solc`]);
