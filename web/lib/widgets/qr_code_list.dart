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

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/download_qrcode.dart';
import 'alert_dialog.dart';
import 'package:selectable/selectable.dart';

class QRCodeList extends StatelessWidget {
  final List<QueryDocumentSnapshot> documents;

  const QRCodeList({required this.documents});

  @override
  Widget build(BuildContext context) {
    try {
      return ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final sortedDocs = documents
            ..sort((doc1, doc2) {
              final Map<String, dynamic>? data1 =
              doc1.data() as Map<String, dynamic>?;
              final Map<String, dynamic>? data2 =
              doc2.data() as Map<String, dynamic>?;
              final createdAt1 =
              (data1?['createdAt'] as Map?)?['date'] as Timestamp?;
              final createdAt2 =
              (data2?['createdAt'] as Map?)?['date'] as Timestamp?;
              return createdAt2?.compareTo(createdAt1 ?? Timestamp(0, 0)) ?? 0;
            });

          final doc = sortedDocs[index];
          final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          final createdAt = (data?['createdAt'] as Map?)?['date'] as Timestamp?;
          final downloadUrl = (data?['qrCodeDetails'] as Map?)?['downloadUrl'] as String?;
          final inputUrl = data?['url'] as String? ?? 'Url non trovato';
          final shortUrl = (data?['shortUrlDetails'] as Map?)?['shortUrl'] as String?;
          final status = data?['status'] as String?;
          final count =
          data?['count'] != null ? int.parse(data?['count'].toString() ?? '0') : 0;
          final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
          final formatted = formatter.format(createdAt?.toDate() ?? DateTime(0));

          return Selectable(
            child: ListTile(
              leading: CircleAvatar(
                //backgroundImage: NetworkImage(downloadUrl),
              ),
              //title: Text(doc.id),
              title: Text(shortUrl ?? 'In lavorazione...'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(inputUrl),
                  Text('ID: ' + count.toString()),
                  Text(formatted),
                  Text(status ?? ''),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: status == 'Completato'
                    ? () async {
                  try {
                    final filePath = '${doc.id}.png';
                    await DownloadQRCode.downloadQRCode(
                        downloadUrl!, 'myQRCode.png');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Download completato")),
                    );
                  } catch (e) {
                    print(e);
                    showAlertDialog(
                        context, 'Error nel download: ' + e.toString());
                  }
                }
                    : null, // Set onPressed to null to disable the button
                child: status == 'Completato'
                    ? Text("DOWNLOAD IMMAGINE")
                    : Text("IN LAVORAZIONE..."),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
      showAlertDialog(context, e.toString());
      return Container();
    }
  }
}
