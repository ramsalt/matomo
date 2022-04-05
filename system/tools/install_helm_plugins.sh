#!/bin/bash
set -euo pipefail

helm plugin install https://github.com/databus23/helm-diff
helm plugin install https://github.com/jkroepke/helm-secrets 
