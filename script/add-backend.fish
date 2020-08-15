#!/usr/bin/env fish

set _region us-central1

function do_func
  argparse -n do_func 'h/help' 'n/name=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "add-backend.fish -n/--name <APP_NAME>"
    return
  end

  set -lq _flag_name
  or set -l _flag_name hello-app

  gcloud beta compute backend-services add-backend $_flag_name-backend-service \
  --global \
  --network-endpoint-group $_flag_name-serverless-neg \
  --network-endpoint-group-region $_region

  gcloud beta compute backend-services list --global
end

do_func $argv
