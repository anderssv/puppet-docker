#!/bin/bash -eu

cd /puppet

puppet apply --modulepath modules manifests/local.pp --no-usecacheonfailure --verbose
