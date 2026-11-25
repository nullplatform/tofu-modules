#!/bin/sh
# Stands in for `np` in this module's tests: nothing here reaches nullplatform.
# It writes what it was asked to a log beside it, one line per call.
printf '%s\n' "$*" >>"$(dirname "$0")/.np-stub.log"
