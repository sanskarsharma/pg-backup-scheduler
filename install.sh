#! /bin/sh

# exit if a command fails
set -e

# install curl to fetch required binaries
apk add curl

# aws-s3-uploader
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
  curl -L --insecure https://github.com/sanskarsharma/aws-s3-uploader/releases/download/v0.4.0/aws-s3-uploader-v0.4.0-arm64 | cat > /usr/local/bin/aws-s3-uploader
else
  curl -L --insecure https://github.com/sanskarsharma/aws-s3-uploader/releases/download/v0.2.0/aws-s3-uploader_v0.2.0_linux_amd64 | cat > /usr/local/bin/aws-s3-uploader
fi
chmod u+x /usr/local/bin/aws-s3-uploader

apk del curl

# cleanup
rm -rf /var/cache/apk/*
