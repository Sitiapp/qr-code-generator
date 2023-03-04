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

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import '../services/request_qrcode.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/qr_code_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _urlController = TextEditingController();
  Uint8List _qrCode = Uint8List(0);
  bool _isLoading = false;

  void _generateQRCode(String url) async {
    setState(() {
      _isLoading = true;
    });

    try {
      _qrCode = Uint8List.fromList(utf8.encode(await generateQRCode(url)));
    } catch (e) {
      showAlertDialog(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
      _urlController.clear(); // Clear the input field after processing the URL
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('Profilo utente'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Image.asset('assets/logo.png', scale: 1),

                      ),
                      const Divider(),
                    ],
                  ),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width <= 500 ? null : 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: 'Inserisci url',
                        prefixText: 'https://',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _generateQRCode(_urlController.text),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('Genera QR Code'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('myCollection')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      showAlertDialog(context, snapshot.error.toString());

                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return QRCodeList(documents: snapshot.data!.docs);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

