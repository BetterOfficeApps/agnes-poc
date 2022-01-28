#!/bin/sh
echo "Initializing S3 for local development."

S3_BUCKET=lendesk-hello-world-local

if awslocal s3api head-bucket --bucket $S3_BUCKET 2>/dev/null
then
    echo "S3 bucket '$S3_BUCKET' already exists. Nothing to be done."
else
    echo "Creating S3 bucket '$S3_BUCKET'."
    awslocal s3api create-bucket --bucket $S3_BUCKET >/dev/null
fi
