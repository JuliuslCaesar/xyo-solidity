/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, April 28, 2018 2:43 PM
 * @Email:  developer@xyfindables.com
 * @Filename: index.js
 * @Last modified by:   arietrouw
 * @Last modified time: Saturday, April 28, 2018 4:46 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

import ERC20 from "./contracts/ERC20.sol"
import XYOfficialTokenSale from "./contracts/XYOfficialTokenSale.sol"
import XYUncalibratedQuery from "./contracts/XYUncalibratedQuery.sol"
import XYCalibratedQuery from "./contracts/XYCalibratedQuery.sol"

const XYO = {
  XYOfficialTokenSale,
  XYUncalibratedQuery,
  XYCalibratedQuery
}

export { ERC20, XYO }
