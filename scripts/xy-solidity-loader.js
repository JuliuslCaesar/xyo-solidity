/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, April 28, 2018 2:08 PM
 * @Email:  developer@xyfindables.com
 * @Filename: xy-solidity-loader.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, April 28, 2018 4:45 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

/* eslint import/no-extraneous-dependencies:0 */

const utils = require(`loader-utils`)

const validateOptions = require(`schema-utils`)

process.env.DEBUG = `*`

const Solc = require(`solc`)
const fs = require(`fs`)
const Debug = require(`debug`)

const debug = Debug(`xyo-solidity`)

const contractFolder = `src/contracts`

const schema = {
  type: `object`,
  properties: {
    name: {
      type: `string`
    }
  }
}

const get = (fileName) => {
  debug(`get: `, fileName)
  return fs.readFileSync(`${fileName}`).toString()
}

const compile = (source) => {
  debug(`compile`)

  const input = {}
  input.main = source

  const findImports = (path) => {
    debug(`findImports: `, path)
    return {
      contents: get(`${contractFolder}/${path}`)
    }
  }

  const solcConfig = {
    sources: input,
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }

  const output = Solc.compile(solcConfig, 1, findImports)

  const result = {}

  Object.keys(output.contracts).forEach((key) => {
    debug("Key: " + key)
    result[key.split('main:')[1]] = output.contracts[key].interface;
  })
  debug("Returning")
  return result
}

// Main exportable logic
const loader = function (source) {
  const options = utils.getOptions(this)

  validateOptions(schema, options, `XY Solidity Loader`)

  return `export default ${JSON.stringify(compile(source))}`
}

module.exports = loader
