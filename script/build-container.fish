#!/usr/bin/env fish

set _project cloudrun-serverless-neg-gs

function do_func
  argparse -n do_func 'h/help' 'n/name=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "build-container.fish -n/--name <IMAGE_NAME>"
    return
  end

  set -lq _flag_name
  or set -l _flag_name hello-app

  cd (pwd |awk -F "/$_project" '{print $1}')/cloudrun-serverless-neg-gs/spring-music-container
  gcloud builds submit --tag gcr.io/(gcloud config get-value project)/$_flag_name
end

do_func $argv
