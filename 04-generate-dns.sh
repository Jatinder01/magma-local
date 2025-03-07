#!/usr/bin/env bash

set -e

export DOMAIN_NAME=magmalocal.com

declare -A loadBalancer_services

loadBalancer_services=( 
  [nginx-proxy]="master.nms"
  [orc8r-nginx-proxy]="api"
  [orc8r-clientcert-nginx]="controller"
  [bootstrapper-orc8r-nginx]="bootstrapper-controller"
)

for svc in "${!loadBalancer_services[@]}"
do

  service_ip="$(kubectl get svc ${svc} \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
  echo ${service_ip} ${loadBalancer_services[${svc}]}.${DOMAIN_NAME}

  if [[ "${svc}" == "nginx-proxy" ]]; then
    echo ${service_ip} magma-test.nms.${DOMAIN_NAME}
  fi

done
