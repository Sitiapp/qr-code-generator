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

const admin = require('firebase-admin')
if (admin.apps.length === 0) {
  admin.initializeApp()
}

const db = admin.firestore()

exports.wk_qrCodes_genShortLink = async (req, res) => {
  if (req.method === 'POST') {
    const data = req?.body?.data
    console.log('data: ', data)
    if (!data) {
      const status = `no data`
      console.error(status)
      updateStatusFs(status, docId)
    }
    var docId = data?.docId
    if (!docId) {
      const status = `no docId`
      console.error(status)
      updateStatusFs(status, docId)
    }
    genShortLink(data, docId)
  } else {
    const status = `This is not a POST request`
    console.error(status)
    updateStatusFs(status, docId)
  }

  async function genShortLink (data, docId) {
    const axios = require('axios')

    // Define the long URL to shorten
    const domainUriPrefix = 'https://YOUR-PROJECT-ID.page.link'
    const link = data?.data?.url

    if (!link) {
      const status = `'link is not defined'`
      console.error(status)
      updateStatusFs(status, docId)
    }
    console.log('link: ', link)
    // Define the request body
    const requestBody = {
      dynamicLinkInfo: {
        domainUriPrefix,
        link
      },
      suffix: {
        option: 'SHORT'
      }
    }

    // Define the API endpoint URL
    const apiUrl =
      'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=YOUR-FIREBASE-API-KEY'

    // Send the API request
    await axios
      .post(apiUrl, requestBody)
      .then(response => {
        const fullShortUrl = response.data.shortLink
        const shortUrl = fullShortUrl.replace('https://', '')
        console.log('Shorst URL:', shortUrl)
        updateQrCodesFs(shortUrl, docId)
      })
      .catch(error => {
        const status = `Error creating short URL:  ${error.response.data.error.message}`
        console.error(status)
        updateStatusFs(status, docId)
      })
  }

  async function updateQrCodesFs (shortUrl, docId) {
    const docRef = db.collection('myCollection').doc(docId)
    docRef
      .set(
        {
          shortUrlDetails: {
            shortUrl,
            createdAt: {
              date: admin.firestore.FieldValue.serverTimestamp()
            }
          },
          status: 'Generazione Qr Code...'
        },
        { merge: true }
      )
      .then(() => {
        console.log('Document updated successfully!')
        return res.status(200).send(shortUrl)
      })
      .catch(error => {
        const status = `Error updating document:  ${error}`
        console.error(status)
        updateStatusFs(status, docId)
      })
  }

  async function updateStatusFs (status, docId) {
    const docRef = db.collection('myCollection').doc(docId)
    docRef
      .set(
        {
          status
        },
        { merge: true }
      )
      .then(() => {
        const status =
          'Error: Document updated successfully wit error status, check function logs for more details'
        console.log(status)
        return res.status(500).send(status)
      })
      .catch(error => {
        const status = `Error updating document: ${error}`
        console.error(status)
        return res.status(500).send(status)
      })
  }
}
