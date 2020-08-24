# Cloud Run configured with Serverless NEG

A network endpoint group (NEG) specifies a group of backend endpoints for a load balancer.
Serverless NEG is a backend that points to a Cloud Run, App Engine, or Cloud Functions service.

- A Cloud Run service or a group of services sharing the same URL pattern.
- A Cloud Functions function or a group of functions sharing the same URL pattern.
- An App Engine app (Standard or Flex), a specific service within an app, or even a specific version of an app.

![lb-serverless-neg](https://cloud.google.com/load-balancing/images/lb-serverless-simple.svg)

## Description

## Demo
### 1. Containerize an app and upload it to Container Registry
- `gcloud builds submit --tag gcr.io/(gcloud config get-value project)/hello-app`

```
$ cd script
$ ./build-container.fish -n hello-app
```

### 2. Cloud Run
#### Deploy App to Cloud Run
- `gcloud run deploy --image <IMAGE_URL> --platform managed --region <REGION> --memory 512M --allow-unauthenticated hello-app`

```
$ cd script
$ ./deploy-cloudrun.fish -i gcr.io/(gcloud config get-value project)/hello-app
```

### 3. Serverless NEG
#### Create Serverless NEG
- `gcloud beta compute network-endpoint-groups create hello-app-serverless-neg --region <REGION> --network-endpoint-type SERVERLESS --cloud-run-service hello-app`

```
$ cd script
$ ./create-serverless-neg.fish -n hello-app
```

### 4. Backend Service
#### Create Backend Service
- `gcloud compute backend-services create hello-app-backend-service --global`

```
$ cd script
$ ./create-backend-service.fish -n hello-app
```

#### Add Serverless NEG to Backend Service
- `gcloud beta compute backend-services add-backend hello-app-backend-service --global --network-endpoint-group hello-app-serverless-neg --network-endpoint-group-region <REGION>`

```
$ cd script
$ ./add-backend.fish -n hello-app
```

### 5. URL Map
#### Create URL Map
- `gcloud compute url-maps create hello-app-url-map --default-service hello-app-backend-service`

```
$ cd script
$ ./create-url-map.fish -n hello-app
```

### SSL Certificate
#### Create Managed SSL Certificate
- `gcloud beta compute ssl-certificates create hello-app-cert --domains <DOMAIN>`

### 6. Target HTTP(s) Proxy
- gcloud compute target-http-proxies
- gcloud compute target-https-proxies

#### Create Target HTTP Proxy
- `gcloud compute target-http-proxies create hello-app-target-http-proxy --url-map hello-app-url-map`

```
$ cd script
$ ./create-target-http-proxy.fish -n hello-app
```

#### Create Target HTTPS Proxy
- `gcloud compute target-https-proxies create hello-app-target-http-proxy --url-map hello-app-url-map --ssl-certificates hello-app-cert`

### Static IP Addresw
#### Reserve a static IP address
- `gcloud compute addresses create --global hello-app-ip`
- `gcloud compute addresses describe --global hello-app-ip`


### 7. Forwarding Rule
#### Create Forwarding Rule for HTTP
- `gcloud compute forwarding-rules create hello-app-forwarding-rule --target-http-proxy hello-app-target-http-proxy --address hello-app-ip --global --ports 80`

```
$ cd script
$ ./create-forwarding-rule.fish -n hello-app
```

#### Create Forwarding Rule for HTTPS
- `gcloud compute forwarding-rules create hello-app-forwarding-rule --target-https-proxy hello-app-target-http-proxy --address hello-app-ip --global --ports 443`

### DNS Record
- Cloud DNS
  - Create Zone
    - DNS name: YOUR_DOMAIN
  - Add Record Set
    - Type A: YOUR_RESERVED_STATIC_IP
- Freenom
  - Service -> My Domains
  - Manage Domain
  - Management Tools -> Nameservers
  - Nameserver from Cloud DNS

### 8. Clean up
- Delete Forwarding Rule
  - `gcloud compute forwarding-rules delete hello-app-forwarding-rule --global --quiet`
- Delete Target HTTP Proxy
  - `gcloud compute target-http-proxies delete hello-app-target-http-proxy --quiet`
- Delete URL Map
  - `gcloud compute url-maps delete hello-app-url-map --quiet`
- Delete Backend Service
  - `gcloud compute backend-services delete hello-app-backend-service --global --quiet`
- Delete Serverless NEG
  - `gcloud beta compute network-endpoint-groups delete hello-app-serverless-neg --region us-central1 --quiet`
- Delete CloudRun Service
  - `gcloud run services delete hello-app --platform managed --region us-central1 --quiet`

## Features

- Forwarding rule
  - The forwarding rule is part of the frontend configuration and contains an external IP address, the IP version (IPv4 or IPv6), a protocol (HTTP or HTTPS (includes HTTP/2), and a port number (80 or 443)
- Target proxy
  - Serverless NEGs can only be used with HTTP and HTTPS target proxies. Services that use serverless NEGs cannot be used with TCP or SSL target proxies
- URL map
  - The forwarding selection for an external HTTP(S) load balancer is based on a URL map. With a URL map, target HTTP(S) proxies determine the backend service to be used by checking the request host name and path in the URL map. Load balancers can have multiple backend services referenced from the URL map. Each backend service can be associated with a different backend type. For example, you can have a backend service for a serverless NEG and another backend service for Compute Engine instance groups.
- Backend service
  - Serverless NEGs can be used as backends for backend services in a load balancer. A backend service can be backed by several serverless NEGs, but each serverless NEG can only point to either the FQDN for a single Cloud Run (fully managed) (or App Engine or Cloud Functions service, or a URL mask that points to multiple services serving at the same domain.

## Requirement

## Usage

## Installation

## Licence

Released under the [MIT license](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/34c6fdd50d54aa8e23560c296424aeb61599aa71/LICENSE)

## Author

[shinyay](https://github.com/shinyay)
