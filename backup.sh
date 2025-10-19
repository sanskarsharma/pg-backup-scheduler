#! /bin/sh

set -e
set -o pipefail

if [ "${AWS_ACCESS_KEY_ID}" = "" ] ||  [ "${AWS_SECRET_ACCESS_KEY}" = "" ] || [ "${AWS_S3_BUCKET}" = "" ] || [ "${AWS_S3_REGION}" = "" ]; then
  echo "You need to set all AWS specific env vars, namely : AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_S3_BUCKET, AWS_S3_REGION."
  exit 1
fi

if [ "${POSTGRES_HOST}" = "" ] ||  [ "${POSTGRES_PORT}" = "" ] || [ "${POSTGRES_USER}" = "" ] || [ "${POSTGRES_PASSWORD}" = "" ] || [ "${POSTGRES_DATABASE}" = "" ]; then
  echo "You need to set all PostgreSQL specific env vars, namely : POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DATABASE."
  exit 1
fi


export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip > dump.sql.gz

echo "Uploading dump to $AWS_S3_BUCKET"

aws-s3-uploader dump.sql.gz $AWS_S3_BUCKET_PATH_PREFIX/$(date -u +"%Y-%m-%d")/${POSTGRES_DATABASE}_$(date -u +"%Y-%m-%dT%H-%M-%SZ").sql.gz

echo "SQL backup uploaded successfully"