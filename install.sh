#! /bin/sh

# exit if a command fails
set -e

# install curl to fetch required binaries
apk add curl

# aws-s3-uploader
curl -L --insecure https://github.com/sanskarsharma/aws-s3-uploader/releases/download/v0.2.0/aws-s3-uploader_v0.2.0_linux_amd64 | cat > /usr/local/bin/aws-s3-uploader
chmod u+x /usr/local/bin/aws-s3-uploader

# go-cron
curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz | zcat > /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron

apk del curl

# cleanup
rm -rf /var/cache/apk/*