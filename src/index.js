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

import ERC20 from "../dist/contracts/ERC20"
import XYOfficialTokenSale from "../dist/contracts/XYOfficialTokenSale"
import XYUncalibratedQuery from "../dist/contracts/XYUncalibratedQuery"
import XYCalibratedQuery from "../dist/contracts/XYCalibratedQuery"

const XYO = {
  OfficialTokenSale: XYOfficialTokenSale,
  UncalibratedQuery: XYUncalibratedQuery,
  CalibratedQuery: XYCalibratedQuery
}

export { XYO, ERC20 }
