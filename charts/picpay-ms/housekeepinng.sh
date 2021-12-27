#!/usr/bin/env bash
set -x
# For each kubernetes kind of interest:
kinds="deployment statefulset configmap secret ingress cronjob hpa certificate PodDisruptionBudget Service ServiceMonitor"
for kind in $kinds; do
  # Get all matching object names where releaseName label matches current release name
  matching=$(kubectl get $kind -n ${infra.kubernetes.namespace} -l release=release-${infra.kubernetes.infraId} -o jsonpath='{.items[*].metadata.name}')
  # For each of these objects check whether releaseNo label matches current release number. Delete if not.
  for obj in $matching; do
    releaseNumber="$(kubectl get $kind -n ${infra.kubernetes.namespace} $obj -o jsonpath='{.metadata.labels.releaseNumber}')"
    if [[ "$releaseNumber" != "${workflow.releaseNo}" ]] && [[ ! -z $releaseNumber ]]; then
      echo Pruning $kind $obj
      kubectl delete $kind -n ${infra.kubernetes.namespace} $obj
    fi
  done
done
