# Shared photo album application

This is the code for the web application created through the "How to Use Cloud
Pub/Sub and Cloud Storage with App Engine" tutorial.

# set some necessary shell variables and prepare your env
```
PROJECT_ID="your-project-id"
PHOTO_BUCKET="name_of_your_photo_bucket"
THUMBNAILS_BUCKET="name_of_your_thumbnails_bucket"

gcloud config set project $PROJECT_ID

gcloud services enable vision.googleapis.com
gcloud services enable storage-component.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable pubsub.googleapis.com 
gcloud services enable datastore.googleapis.com

SERVICE_ACCOUNT_EMAIL=$(gcloud projects get-iam-policy $PROJECT_ID | grep cloudbuild.gserviceaccount.com | head -1 | awk -F: '{print $2}')
gcloud projects add-iam-policy-binding $PROJECT_ID \
     --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
     --role roles/appengine.appAdmin
```

# create the buckets
```
gsutil mb -l eu -p $PROJECT_ID gs://$PHOTO_BUCKET
gsutil iam ch allUsers:objectViewer gs://$PHOTO_BUCKET

gsutil mb -l eu -p $PROJECT_ID gs://$THUMBNAILS_BUCKET
```

# create the GAE APP
```
gcloud app create --region europe-west
gcloud container builds submit . --config cloudbuild.yaml --substitutions=_PHOTO_BUCKET=$PHOTO_BUCKET,_THUMBNAILS_BUCKET=$THUMBNAILS_BUCKET
```

# create pubsub subscription
```
gcloud pubsub topics create $PHOTO_BUCKET
gcloud pubsub subscriptions create mySubscription --topic $PHOTO_BUCKET --push-endpoint="https://$PROJECT_ID.appspot.com/_ah/push-handlers/receive_message"
```

# create notification for bucket 
```
gsutil notification create -f json gs://$PHOTO_BUCKET
```

# test the upload
```
gsutil cp test/stockholm.jpg gs://$PHOTO_BUCKET
```

# check the web app gallery for the VisionAPI tags
```
gcloud app browse --project=$PROJECT_ID
```
