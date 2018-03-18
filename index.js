/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Wednesday, February 28, 2018 12:49 PM
 * @Email:  developer@xyfindables.com
 * @Filename: index.js
 * @Last modified by:   arietrouw
 * @Last modified time: Sunday, March 18, 2018 11:34 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

const debug = require(`debug`)(`xyo-solidity`);
const fs = require(`fs`);
const SOLC = require(`solc`);
const PATH = require(`path`);

class Contracts {
  load(_filename, callback) {
    const folder = PATH.dirname(_filename);
    const filename = PATH.basename(_filename);
    const root = PATH.basename(_filename, `.sol`);
    const cwd = process.cwd();

    process.chdir(folder);

    const input = {};
    input[filename] = this.get(_filename);

    debug(`input: `, input);

    const findImports = (path) => {
      debug(`findImports: `, path);
      return {
        contents: this.get(path),
      };
    };

    const solcConfig = {
      sources: input,
      settings: {
        optimizer: {
          enabled: true,
          runs: 500,
        },
        outputSelection: {
          "*": [`metadata`, `evm.bytecode`],
        },
      },
    };

    const output = SOLC.compile(solcConfig, 1, findImports);

    process.chdir(cwd);

    if (output.errors && output.errors.length > 0) {
      callback(output.errors, output.contracts[`${filename}:${root}`]);
    } else {
      callback(null, output.contracts[`${filename}:${root}`]);
    }
  }

  compile(source, contractName) {
    debug(`compile`);

    const input = {};
    input.main = source;

    debug(`input: `, input);

    const findImports = (path) => {
      debug(`findImports: `, path);
      return {
        contents: this.get(path),
      };
    };

    const output = SOLC.compile({
      sources: input,
    }, 1, findImports);

    debug(`output: `, output);

    return output.contracts[`main:${contractName}`];
  }

  get(fileName) {
    debug(`get: `, fileName);
    return fs.readFileSync(`${fileName}`).toString();
  }
}

class XYOSolidity {
  constructor() {
    debug(`constructor`);
    this.contracts = new Contracts();
  }
}

module.exports = XYOSolidity;
