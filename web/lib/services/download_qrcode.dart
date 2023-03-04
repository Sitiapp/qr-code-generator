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

import 'dart:typed_data';
import 'dart:html';

class DownloadQRCode {
  static Future<void> downloadQRCode(
      String downloadUrl, String fileName) async {
    try {
      final response =
      await HttpRequest.request(downloadUrl, responseType: 'blob');
      final blob = response.response;
      final anchor = AnchorElement(href: Url.createObjectUrlFromBlob(blob))
        ..download = fileName
        ..style.display = 'none';

      document.body!.children.add(anchor);
      anchor.click();
      document.body!.children.remove(anchor);
      Url.revokeObjectUrl(anchor.href!);
    } catch (error) {
      print('Error downloading QR code: $error');
      throw error;
    }
  }
}
