#!/usr/bin/env fish

set _region us-central1

function do_func
  argparse -n do_func 'h/help' 'i/image=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "deploy-cloudrun.fish -i/--image <APPLICATION_IMAGE>"
    return
  end

  set -lq _flag_image
  or set -l _flag_image gcr.io/google-samples/hello-app:1.0

  gcloud run deploy --image $_flag_image --platform managed --region $_region --memory 512M --allow-unauthenticated hello-app
end

do_func $argv
