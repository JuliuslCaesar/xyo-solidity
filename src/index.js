/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Saturday, April 28, 2018 2:43 PM
 * @Email:  developer@xyfindables.com
 * @Filename: index.js
 * @Last modified by:   carterharrison
 * @Last modified time: 2018-05-24T14:38:41-07:00
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

import ERC20 from "../dist/contracts/ERC20"
import XYOfficialTokenSale from "../dist/contracts/XYOfficialTokenSale"
import XYUncalibratedQuery from "../dist/contracts/XYUncalibratedQuery"
import XYCalibratedQuery from "../dist/contracts/XYCalibratedQuery"
import XYGammaSale from "../dist/contracts/XYRatchetSale"

const XYO = {
  OfficialTokenSale: XYOfficialTokenSale,
  UncalibratedQuery: XYUncalibratedQuery,
  CalibratedQuery: XYCalibratedQuery,
  GammaSale: XYGammaSale
}

export { XYO, ERC20 }
