/*
 * Copyright 2023 Nicola Pigozzo - www.sitiapp.it
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


const wk_qrCodes_onWrite = require('./wk_qrCodes_onWrite')
const wk_qrCodes_genShortLink = require('./wk_qrCodes_genShortLink')
const wk_qrCodes_genQrCode = require('./wk_qrCodes_genQrCode')

exports.wk_qrCodes_onWrite = wk_qrCodes_onWrite.wk_qrCodes_onWrite
exports.wk_qrCodes_genShortLink =
  wk_qrCodes_genShortLink.wk_qrCodes_genShortLink
exports.wk_qrCodes_genQrCode = wk_qrCodes_genQrCode.wk_qrCodes_genQrCode
