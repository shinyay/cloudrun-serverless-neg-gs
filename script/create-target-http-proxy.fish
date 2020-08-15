#!/usr/bin/env fish

function do_func
  argparse -n do_func 'h/help' 'n/name=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "create-target-http-proxy.fish -n/--name <APP_NAME>"
    return
  end

  set -lq _flag_name
  or set -l _flag_name hello-app

  gcloud compute target-http-proxies create $_flag_name-target-http-proxy --url-map $_flag_name-url-map

  gcloud compute target-http-proxies list
end

do_func $argv