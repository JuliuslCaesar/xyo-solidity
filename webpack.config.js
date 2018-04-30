/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, April 28, 2018 2:35 PM
 * @Email:  developer@xyfindables.com
 * @Filename: webpack.config.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, April 28, 2018 8:38 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

const path = require(`path`)

module.exports = [{
  mode: `production`,
  entry: [
    `./src/index.js`
  ],
  output: {
    path: path.resolve(__dirname, `dist`),
    filename: `index.js`
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: [`babel-loader`]
      },
      {
        test: /\.sol$/,
        include: [
          path.resolve(__dirname, `src/contracts`)
        ],
        use: {
          loader: `./scripts/xy-solidity-loader`,
          options: {
            solc: {
            }
          }
        },
      }
    ]
  },
  resolve: {
    extensions: [`*`, `.js`, `.jsx`, `.sol`]
  },
  target: `node`
}]
