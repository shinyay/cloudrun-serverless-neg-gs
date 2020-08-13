# Cloud Run configured with Serverless NEG

A network endpoint group (NEG) specifies a group of backend endpoints for a load balancer.
Serverless NEG is a backend that points to a Cloud Run, App Engine, or Cloud Functions service.

- A Cloud Run service or a group of services sharing the same URL pattern.
- A Cloud Functions function or a group of functions sharing the same URL pattern.
- An App Engine app (Standard or Flex), a specific service within an app, or even a specific version of an app.

![lb-serverless-neg](https://cloud.google.com/load-balancing/images/lb-serverless-simple.svg)

## Description

## Demo
### Containerize an app and upload it to Container Registry

```
$ cd spring-music-container
$ gcloud builds submit --tag gcr.io/(gcloud config get-value project)/hello-app
```

## Features

- feature:1
- feature:2

## Requirement

## Usage

## Installation

## Licence

Released under the [MIT license](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/34c6fdd50d54aa8e23560c296424aeb61599aa71/LICENSE)

## Author

[shinyay](https://github.com/shinyay)