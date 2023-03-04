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

const { ExecutionsClient } = require('@google-cloud/workflows')
const client = new ExecutionsClient()

exports.wk_qrCodes_onWrite = functions
  .region('YOUR-REGION')
  .firestore.document('myCollection/{docId}')
  .onCreate(async (snapshot, context) => {
    // Access the document data as an object
    callWorkflowsAPI(snapshot, context)
  })

/**
 * Calls the Workflow API and waits for the execution result.
 */
async function callWorkflowsAPI (snapshot, context) {
  const location = 'YOUR-REGION'
  const workflow = 'YOUR-WORKFLOW-ID'
  const data = snapshot.data()
  const docId = context.params.docId

  // Execute workflow
  try {
    const projectId = 'YOUR-PROJECT-ID'

    const createExecutionRes = await client.createExecution({
      parent: client.workflowPath(projectId, location, workflow),
      execution: {
        argument: JSON.stringify({
          data,
          docId
        })
      }
    })
    const executionName = createExecutionRes[0].name
    console.log(`Created execution: ${executionName}`)
    console.log(`docId is: ${docId}`)

    // Wait for execution to finish, then print results.
    let executionFinished = false
    let backoffDelay = 1000 // Start wait with delay of 1,000 ms
    console.log('Poll every second for result...')
    while (!executionFinished) {
      const [execution] = await client.getExecution({
        name: executionName
      })
      executionFinished = execution.state !== 'ACTIVE'

      // If we haven't seen the result yet, wait a second.
      if (!executionFinished) {
        console.log('- Waiting for results...')
        await new Promise(resolve => {
          setTimeout(resolve, backoffDelay)
        })
        backoffDelay *= 2 // Double the delay to provide exponential backoff.
      } else {
        console.log(`Execution finished with state: ${execution.state}`)
        console.log(execution.result)
        return {
          success: true,
          result: execution.result
        }
      }
    }
  } catch (e) {
    console.error(`Error executing workflow: ${e}`)
    return {
      success: false
    }
  }
}
