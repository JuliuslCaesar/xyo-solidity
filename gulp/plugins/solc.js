/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Sunday, April 29, 2018 7:34 PM
 * @Email:  developer@xyfindables.com
 * @Filename: solcBuild.js
 * @Last modified by:   arietrouw
 * @Last modified time: Monday, April 30, 2018 11:01 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

const through = require(`through2`)
const Solc = require(`solc`)
const fs = require(`fs`)
const debug = require(`debug`)(`xyo-gulp-solc`)

module.exports = function (_options) {
  const options = _options || {}
  debug(`options: ${JSON.stringify(options)}`)

  const folder = options.folder || `./src/contracts`
  const makeModule = options.makeModule || false
  const mask = options.mask || {
    assembly: true,
    bytecode: true,
    functionHashes: true,
    gasEstimates: true,
    interface: true,
    metaData: true,
    opcodes: true,
    runtimeBytecode: true,
    srcmap: true,
    srcmapRuntime: true
  }

  const applyMask = (inObj) => {
    const outObj = {}
    Object.keys(mask).forEach((key) => {
      if (mask[key]) {
        outObj[key] = inObj[key]
      }
    })
    return outObj
  }

  const compileSolc = (_file, encoding, callback) => {
    debug(`compileSolc: ${_file.history}`)
    let code = null
    const file = _file

    if (file.isBuffer()) {
      code = file.contents.toString()
    } else if (file.isStream()) {
      code = file.contents.read()
    }

    const get = (fileName) => {
      debug(`get: `, fileName)
      return fs.readFileSync(`${fileName}`).toString()
    }

    const input = {}
    input.main = code

    const findImports = path => ({
      contents: get(`${folder}/${path}`)
    })

    const solcConfig = {
      sources: input,
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      },
    }

    const output = Solc.compile(solcConfig, 1, findImports)

    if (output.errors) {
      callback(output.errors)
      return
    }

    let result = null

    Object.keys(output.contracts).forEach((key) => {
      debug(`key: ${key}`)
      const parts = key.split(`:`)
      if (parts.length > 1) {
        if (parts[0] === `main`) {
          if (!result) { // the first result with main: is the contract
            result = applyMask(output.contracts[key], mask)
          }
        }
      }
    })

    if (!result) {
      result = output
    }

    result = JSON.stringify(result)

    // debug(`result: ${result}`)

    if (makeModule) {
      file.contents = Buffer.from(`module.exports = ${result}`)
    } else {
      file.contents = Buffer.from(result)
    }

    callback(null, file)
  }

  return through.obj(compileSolc)
}
