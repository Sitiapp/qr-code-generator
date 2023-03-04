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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> generateQRCode(String url) async {
  try {
    assert(FirebaseAuth.instance.currentUser != null);

    // Add a null check for the url variable
    if (url == null) {
      throw Exception('URL is null');
    }

    url = "https://$url";

    // Write to Firestore
    final CollectionReference qrCodesCollection =
        FirebaseFirestore.instance.collection('myCollection');
    await qrCodesCollection.add({
      'url': url,
      'createdAt': {'date': FieldValue.serverTimestamp()},
      'status': 'Generazione Short Link...'
    });

    return 'ok';
  } catch (e) {
    print('Error on try catch: $e');
    throw e;
  }
}
