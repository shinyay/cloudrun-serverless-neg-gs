#!/usr/bin/env fish

function do_func
  argparse -n do_func 'h/help' 'n/name=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "create-url-map.fish -n/--name <APP_NAME>"
    return
  end

  set -lq _flag_name
  or set -l _flag_name hello-app

  gcloud compute url-maps create $_flag_name-url-map --default-service $_flag_name-backend-service
end

do_func $argv