#! /bin/sh

set -e

if [ "${SCHEDULE}" = "" ]; then
  echo "No SCHEDULE set, running backup once immediately..."
  sh backup.sh
else
  echo "Setting up scheduled backups..."

  # Convert special schedules to cron format
  case "$SCHEDULE" in
    @yearly|@annually) CRON_SCHEDULE="0 0 1 1 *" ;;
    @monthly) CRON_SCHEDULE="0 0 1 * *" ;;
    @weekly) CRON_SCHEDULE="0 0 * * 0" ;;
    @daily|@midnight) CRON_SCHEDULE="0 0 * * *" ;;
    @hourly) CRON_SCHEDULE="0 * * * *" ;;
    *) CRON_SCHEDULE="$SCHEDULE" ;;
  esac

  echo "Schedule: $SCHEDULE"
  echo "Cron format: $CRON_SCHEDULE"

  # Create crontab entry
  echo "$CRON_SCHEDULE /bin/sh /backup.sh" > /etc/crontabs/root

  echo "Crontab configured successfully:"
  cat /etc/crontabs/root

  echo "Starting crond service..."
  # Start crond in foreground with logging
  exec crond -f -l 2
fi