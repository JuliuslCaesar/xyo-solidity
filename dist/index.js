"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.ERC20 = exports.XYO = undefined;

var _ERC = require("../dist/contracts/ERC20");

var _ERC2 = _interopRequireDefault(_ERC);

var _XYOfficialTokenSale = require("../dist/contracts/XYOfficialTokenSale");

var _XYOfficialTokenSale2 = _interopRequireDefault(_XYOfficialTokenSale);

var _XYUncalibratedQuery = require("../dist/contracts/XYUncalibratedQuery");

var _XYUncalibratedQuery2 = _interopRequireDefault(_XYUncalibratedQuery);

var _XYCalibratedQuery = require("../dist/contracts/XYCalibratedQuery");

var _XYCalibratedQuery2 = _interopRequireDefault(_XYCalibratedQuery);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, April 28, 2018 2:43 PM
 * @Email:  developer@xyfindables.com
 * @Filename: index.js
 * @Last modified by:   arietrouw
 * @Last modified time: Monday, April 30, 2018 10:28 AM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

var XYO = {
  OfficialTokenSale: _XYOfficialTokenSale2.default,
  UncalibratedQuery: _XYUncalibratedQuery2.default,
  CalibratedQuery: _XYCalibratedQuery2.default
};

exports.XYO = XYO;
exports.ERC20 = _ERC2.default;