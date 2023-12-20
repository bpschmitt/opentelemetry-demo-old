#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path/.."

# TODO: These need to be parameterized and this script needs to be integrated with a CI workflow
export DEMO_VERSION="1.7.0"
export PROJECT_ID=<set project id>
export NEW_RELIC_OTLP_ENDPOINT=<NR endpoint>
export NEW_RELIC_API_KEY_NRDOT=<NR key for telemetry routed through NRDOT>
export NEW_RELIC_API_KEY_OTEL=<NR key for telemetry from regular demo collector>

envsubst < newrelic/newrelic-helm-values.yaml > newrelic/newrelic-helm-values-modified.yaml
rm newrelic/newrelic-helm-values.yaml
mv newrelic/newrelic-helm-values-modified.yaml newrelic/newrelic-helm-values.yaml

envsubst < kubernetes/newrelic-nrdot.yaml > kubernetes/newrelic-nrdot-modified.yaml
rm kubernetes/newrelic-nrdot.yaml
mv kubernetes/newrelic-nrdot-modified.yaml kubernetes/newrelic-nrdot.yaml

make generate-kubernetes-manifests

# TODO: After running this script the following is roughly what to run in order to deploy the demo
# kubectl delete -f kubernetes -n otel-demo
# kubectl apply -f kubernetes -n otel-demo
