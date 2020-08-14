#!/usr/bin/env fish

set _region us-central1

function do_func
  argparse -n do_func 'h/help' 'n/name=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "create-serverless-neg.fish -n/--name <APP_NAME>"
    return
  end

  set -lq _flag_name
  or set -l _flag_name hello-app

  gcloud beta compute network-endpoint-groups create $_flag_name-serverless-neg \
  --region $_region \
  --network-endpoint-type SERVERLESS \
  --cloud-run-service $_flag_name
end

do_func $argv
