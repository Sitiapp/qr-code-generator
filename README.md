# QR Code Generator - v 0.01.00 beta 🚀

## Info:

This repository provides you a simple Google Cloud Web App that generate QR Codes

## DEMO

Ask me for credentials at info@sitiapp.it

$ https://sitiapp-qrcodegen-demo.web.app/

## PREVIEW

### Login Screen

![Alt text](login.png?raw=true "Login Screen")

### Forgot Passowrd

![Alt text](forgot-password.png?raw=true "Forgot Passowrd Screen")

### User Details

![Alt text](user-details.png?raw=true "User Details Screen")

### Login Screen

![Alt text](qr-code-list.png?raw=true "QR Codes List Screen")

## DOWNLOAD - step 1 (required)

    $ git clone https://github.com/Sitiapp/qr-code-generator.git

## CONFIGURATION - step 2 (required)

1. Create a new project on Google Cloud Platform: (See #1)
2. Enable billing for your new project (Link: https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_project)
3. Create a service account: (See #2)

   $ gcloud iam service-accounts create cloud-function-invoker --description="This service account for cloud functions" --display-name="cloud-function-invoker"

4. Add roles to new created service account: (Link #2)

   $ gcloud projects add-iam-policy-binding `<YOUR-PROJECT-ID>` --member="serviceAccount:cloud-function-invoker@`<YOUR-PROJECT-ID>`.iam.gserviceaccount.com" --role="roles/cloudfunctions.invoker" --role="roles/storage.objectAdmin"
   --role="roles/workflows.invoker"

## INSTALLATION - step 3 (required)

1. Edit variables on env.yaml file
2. Install node modules

   $ cd qr-code-generator/functions

   $ npm i --s

3. Deploy Cloud functions: (Link #3 and #4)

   $ cd qr-code-generator/functions

   $ gcloud functions deploy wk_qrCodes_genQrCode --entry-point wk_qrCodes_genQrCode --runtime nodejs16 --trigger-http --region YOUR-REGION --service-account YOUR-SERVICE-ACCOUNT-ID --env-vars-file .env.yaml

   $ gsutil cors set cors.json gs://YOUR-BUCKET-NAME

   $ gsutil cors get gs://YOUR-BUCKET-NAME

   $ gcloud functions deploy wk_qrCodes_genShortLink --entry-point wk_qrCodes_genShortLink --runtime nodejs16 --trigger-http --region YOUR-REGION --service-account YOUR-SERVICE-ACCOUNT-ID --env-vars-file .env.yaml

   $ gcloud functions deploy wk_qrCodes_onWrite --runtime=nodejs16 --trigger-event=providers/cloud.firestore/eventTypes/document.create --trigger-resource="projects/YOUR-PROJECT-ID/databases/(default)/documents/myCollection/{docId}" --region YOUR-REGION --service-account YOUR-SERVICE-ACCOUNT-ID --env-vars-file .env.yaml

4. Create Google Cloud Workflow: (Link #5)

   $ gcloud workflows deploy YOUR-WORKFLOW-ID --source=../../workflow.yaml --service-account=cloud-function-invoker@`<YOUR-PROJECT-ID>`.iam.gserviceaccount.com

### Created by:

<img src="https://firebasestorage.googleapis.com/v0/b/sitiapp-logo-public/o/sitiapp-logo_horrizontal.png?alt=media&token=97303a06-192d-4a11-a51b-646b96f46e50" width="200">

### Contact Developer:

Email: info@sitiapp.it  
Website: www.sitiapp.it

### Documentation:

1. [#1 Google Cloud Create a Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project)
2. [#2 Google Cloud Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts#iam-service-accounts-create-gcloud)
3. [#3 Google Cloud Environment variables](https://github.com/simonprickett/google-cloud-functions-environment-variables/blob/master/README.md)
4. [#4 Google Cloud Regions zone](https://cloud.google.com/compute/docs/regions-zones)
5. [#5 Google Cloud create a Workflow](https://cloud.google.com/workflows/docs/creating-updating-workflow#create_a_workflow)
