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


'use strict'

const functions = require('firebase-functions')
const qrcode = require('qrcode')
const { Storage } = require('@google-cloud/storage')
const admin = require('firebase-admin')

const storage = new Storage()
const bucket = storage.bucket('YOUR-BUCKET-NAME')

if (admin.apps.length === 0) {
  admin.initializeApp()
}
const db = admin.firestore()

exports.wk_qrCodes_genQrCode = async (req, res) => {
  if (req.method === 'POST') {
    const data = req?.body?.data
    if (!data) {
      console.log('no data')
      return res.status(400).send('no data')
    }
    const docId = data?.docId
    if (!docId) {
      console.log('no docId')
      return res.status(400).send('no docId')
    }
    console.log('docId: ', docId)
    getShortUrlFs(docId)
  } else {
    console.log('This is not a POST request')
    return res.status(404)
  }

  async function getShortUrlFs (docId) {
    // Use the shortLink_output value in your Cloud Function logic
    const docRef = db.collection('myCollection').doc(docId)
    const doc = await docRef.get()
    if (!doc.exists) {
      console.log('No such document!')
      return res.status(400).send('No such document!')
    }
    const shortUrl = doc.data()?.shortUrlDetails?.shortUrl
    if (!shortUrl) {
      console.log('No shortUrl')
      return res.status(400).send('No shortUrl')
    }

    console.log(`The value of shortUrl is: ${shortUrl}`)
    genQrCode(docId, shortUrl)
  }

  async function genQrCode (docId, shortUrl) {
    const options = {
      errorCorrectionLevel: 'L', // low error correction level
      margin: 4, // add a small margin around the QR code
      scale: 10, // set the size of each QR code module (pixel)
      type: 'image/png',
      width: 2000, // Set width to 2000 pixels
      height: 2000, // Set height to 2000 pixels
      quality: 1
    }

    const buffer = await new Promise((resolve, reject) => {
      qrcode.toBuffer(shortUrl, options, (err, buffer) => {
        if (err) {
          const errorMessage = 'Error generating QR code: ' + err
          console.error(msg)
          reject(msg)
          console.error(errorMessage)
          throw new functions.https.HttpsError(400, errorMessage, {
            errorMessage
          })
        } else {
          resolve(buffer)
        }
      })
    })

    const fileName = `${Date.now()}.png`
    const file = bucket.file(fileName)

    await new Promise((resolve, reject) => {
      const stream = file.createWriteStream({
        metadata: { contentType: 'image/png' }
      })

      stream.on('error', err => {
        const errorMessage = `Error writing file to GCS: ${err}`
        reject(err)
        console.error(errorMessage)
        throw new functions.https.HttpsError(400, errorMessage, {
          errorMessage
        })
      })

      stream.on('finish', () => {
        resolve()
      })

      stream.end(buffer)
    })

    const downloadUrlArray = await file
      .getSignedUrl({
        action: 'read',
        expires: '03-09-2491'
      })
      .then(res => {
        console.log('Signed URL:', res)
        return res
      })
      .catch(error => {
        const errorMessage = `Error getting signed URL: ${error}`
        console.error(errorMessage)
        throw new functions.https.HttpsError(400, errorMessage, {
          errorMessage
        })
      })

    if (downloadUrlArray.length > 0) {
      const downloadUrl = downloadUrlArray[0]
      console.log(`Download URL generated: ${downloadUrl}`)
      writeToFs(downloadUrl, docId)
    } else {
      const errorMessage = `'Empty download URL array: ', ${JSON.stringify(
        downloadUrlArray
      )}`
      console.error(errorMessage)
      throw new functions.https.HttpsError(400, errorMessage, {
        errorMessage
      })
    }
  }

  async function writeToFs (downloadUrl, docId) {
    const docRef = db.collection('myCollection').doc(docId)
    docRef
      .set(
        {
          qrCodeDetails: {
            downloadUrl,
            createdAt: {
              date: admin.firestore.FieldValue.serverTimestamp()
            }
          },
          status: 'Completato'
        },
        { merge: true }
      )
      .then(() => {
        console.log('Document updated successfully!')
        return res.status(200).send('Document updated successfully!')
      })
      .catch(error => {
        console.error('Error updating document: ', error)
        return res.status(500).send('Error updating document: ', error)
      })
  }
}
