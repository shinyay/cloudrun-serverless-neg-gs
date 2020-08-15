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

  gcloud compute forwarding-rules create $_flag_name-forwarding-rule \
  --target-http-proxy $_flag_name-target-http-proxy \
  --global \
  --ports 80

  gcloud compute forwarding-rules describe $_flag_name-forwarding-rule \
  --global \
  --format "value(IPAddress)"
end

do_func $argv