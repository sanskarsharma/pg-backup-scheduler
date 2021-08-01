# pg-backup-scheduler

Takes routine pg_dumps of your postgres database and uploads them to aws-s3 (using another utility I wrote : [aws-s3-uploader](https://github.com/sanskarsharma/aws-s3-uploader)). Run as a lean docker deployment.

Forked and modified from [schickling/dockerfiles -> postgres-backup-s3](https://github.com/schickling/dockerfiles/tree/master/postgres-backup-s3). 


## Usage

Docker images available at https://hub.docker.com/r/sanskarsharma/pg-backup-scheduler. Image tags correspond to the git tags.

Docker:
```sh
$ docker run -e AWS_ACCESS_KEY_ID=key -e AWS_SECRET_ACCESS_KEY=secret -e AWS_S3_BUCKET=my-bucket -e AWS_S3_BUCKET_PATH_PREFIX=backup -e AWS_S3_REGION=ap-south-1 -e POSTGRES_DATABASE=dbname -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_HOST=localhost -e POSTGRES_PORT=5432 sanskarsharma/pg-backup-scheduler:v0.1.0
```

Docker Compose:
```yaml
postgres:
  image: postgres
  environment:
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password

pg-backup-scheduler:
  image: sanskarsharma/pg-backup-scheduler:v0.1.0
  links:
    - postgres
  environment:
    
    AWS_ACCESS_KEY_ID: key
    AWS_SECRET_ACCESS_KEY: secret
    AWS_S3_REGION: ap-south-1
    AWS_S3_BUCKET: bucketname
    AWS_S3_BUCKET_PATH_PREFIX: backup

    POSTGRES_HOST: host
    POSTGRES_PORT: 5432
    POSTGRES_DATABASE: dbname
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
    POSTGRES_EXTRA_OPTS: '--schema=public --blobs'

    SCHEDULE: '@daily'

```

### Automatic Periodic Backups

You can additionally set the `SCHEDULE` environment variable like `-e SCHEDULE="@daily"` to run the backup automatically.

More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).
