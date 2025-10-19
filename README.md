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
  image: ghcr.io/sanskarsharma/pg-backup-scheduler:v0.4.8
  links:
    - postgres
  environment:

    AWS_ACCESS_KEY_ID: key
    AWS_SECRET_ACCESS_KEY: secret
    AWS_S3_REGION: ap-south-1
    AWS_S3_BUCKET: bucketname
    AWS_S3_BUCKET_PATH_PREFIX: backup

    POSTGRES_HOST: postgres
    POSTGRES_PORT: 5432
    POSTGRES_DATABASE: dbname
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
    POSTGRES_EXTRA_OPTS: '--schema=public --blobs'

    SCHEDULE: '@daily'

```

### Automatic Periodic Backups

You can additionally set the `SCHEDULE` environment variable to run backups automatically using standard cron syntax.

#### Scheduling Options

**Special Schedules:**
- `@hourly` - Run every hour at the beginning of the hour
- `@daily` or `@midnight` - Run once a day at midnight
- `@weekly` - Run once a week at midnight on Sunday
- `@monthly` - Run once a month at midnight on the first day
- `@yearly` or `@annually` - Run once a year at midnight on January 1st

**Standard Cron Format:**
```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 6) (Sunday to Saturday)
│ │ │ │ │
│ │ │ │ │
* * * * *
```

**Examples:**
- `* * * * *` - Every minute
- `0 * * * *` - Every hour at minute 0
- `*/15 * * * *` - Every 15 minutes
- `0 2 * * *` - Every day at 2:00 AM
- `0 0 * * 0` - Every Sunday at midnight
- `30 3 1 * *` - At 3:30 AM on the first day of every month

**Example Usage:**
```sh
# Run backup every hour
docker run -e SCHEDULE="@hourly" ... sanskarsharma/pg-backup-scheduler:v0.1.0

# Run backup every hour (alternative cron syntax)
docker run -e SCHEDULE="0 * * * *" ... sanskarsharma/pg-backup-scheduler:v0.1.0

# Run backup daily at 2 AM
docker run -e SCHEDULE="0 2 * * *" ... sanskarsharma/pg-backup-scheduler:v0.1.0
```
