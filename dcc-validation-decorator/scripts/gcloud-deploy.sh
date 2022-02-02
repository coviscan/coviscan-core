#!/bin/bash

GCLOUD_PROJECT_ID="dentsads"
SERVICE_ACCOUNT_NAME="dgca-val-decorator-invoker"
SERVICE_ACCOUNT_EMAIL="$SERVICE_ACCOUNT_NAME@$GCLOUD_PROJECT_ID.iam.gserviceaccount.com"
CLOUD_RUN_NAME="dgca-validation-decorator"

DOCKER_REGISTRY="us-central1-docker.pkg.dev"
PROJECT="$GCLOUD_PROJECT_ID"
REPOSITORY="dgca-validation-decorator"

INSTANCE_CONNECTION_NAME="dentsads:us-central1:dgca-validation-decorator-postgres"

# get fresh keys for Germany from:
# https://github.com/lovasoa/sanipasse/blob/master/src/assets/Digital_Green_Certificate_Signing_Keys.json
# https://de.dscg.ubirch.com/trustList/DSC/

# create service account with cloud run invoker role
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME

gcloud projects add-iam-policy-binding $GCLOUD_PROJECT_ID \
  --member "serviceAccount:$SERVICE_ACCOUNT_NAME@$GCLOUD_PROJECT_ID.iam.gserviceaccount.com" \
  --role "roles/run.invoker"

gcloud projects add-iam-policy-binding $GCLOUD_PROJECT_ID \
  --member "serviceAccount:$SERVICE_ACCOUNT_NAME@$GCLOUD_PROJECT_ID.iam.gserviceaccount.com" \
  --role "roles/cloudsql.client"

gcloud projects add-iam-policy-binding $GCLOUD_PROJECT_ID \
  --member "serviceAccount:$SERVICE_ACCOUNT_NAME@$GCLOUD_PROJECT_ID.iam.gserviceaccount.com" \
  --role "roles/secretmanager.secretAccessor"

# deploy cloud run app
gcloud run deploy $CLOUD_RUN_NAME \
  --image $DOCKER_REGISTRY/$PROJECT/$REPOSITORY/dgca-validation-decorator:latest \
  --platform managed \
  --region="us-central1" \
  --service-account="$SERVICE_ACCOUNT_EMAIL" \
  --max-instances=1 \
  --allow-unauthenticated \
  --add-cloudsql-instances="dentsads:us-central1:dgca-validation-decorator-postgres" \
  --update-env-vars="SERVER_PORT=8080" \
  --update-env-vars="SPRING_PROFILES_ACTIVE=cloud" \
  --update-env-vars="SPRING_DATASOURCE_URL=$INSTANCE_CONNECTION_NAME" \
  --update-secrets="/ec/prod/app/san/dgc/dev-decorator.jks=DEV_DECORATOR_JKS:latest" \
  --update-secrets="SPRING_DATASOURCE_USERNAME=SPRING_DATASOURCE_USERNAME:latest" \
  --update-secrets="SPRING_DATASOURCE_PASSWORD=SPRING_DATASOURCE_PASSWORD:latest"

  # If no unauthenticated access is allowed you can curl like this:
  # curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" https://dgca-validation-decorator-s5id3424fq-uc.a.run.app/identity