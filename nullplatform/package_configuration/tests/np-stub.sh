#!/bin/sh
# Stands in for `np` in this module's tests: nothing here reaches nullplatform.
# It writes what it was asked to a log beside it, one line per call, and
# answers `package status` with the record of one place, already through the
# filter the module gives (what the real command prints with --query).
log="$(dirname "$0")/.np-stub.log"
printf '%s\n' "$*" >>"$log"
if [ "$1 $2" = "package status" ]; then
  printf '%s\n' '{"status":"active","version":"1.2.3","message":"","outputs":"{\"placement.cluster.namespace\":\"dummy-namespace\",\"replicas\":2}","resources":"[{\"name\":\"channel\",\"resource_type\":\"notification_channel\",\"id\":\"123\",\"ref\":\"notification_channel/channel\",\"origin\":\"created\"}]"}'
fi
