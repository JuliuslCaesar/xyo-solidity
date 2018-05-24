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

var _XYRatchetSale = require("../dist/contracts/XYRatchetSale");

var _XYRatchetSale2 = _interopRequireDefault(_XYRatchetSale);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var XYO = {
  OfficialTokenSale: _XYOfficialTokenSale2.default,
  UncalibratedQuery: _XYUncalibratedQuery2.default,
  CalibratedQuery: _XYCalibratedQuery2.default,
  GammaSale: _XYRatchetSale2.default
}; /**
    * @Author: XY | The Findables Company <arietrouw>
    * @Date:   Saturday, April 28, 2018 2:43 PM
    * @Email:  developer@xyfindables.com
    * @Filename: index.js
    * @Last modified by:   carterharrison
    * @Last modified time: 2018-05-24T14:38:41-07:00
    * @License: All Rights Reserved
    * @Copyright: Copyright XY | The Findables Company
    */

exports.XYO = XYO;
exports.ERC20 = _ERC2.default;