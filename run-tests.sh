#!/bin/bash

set -e

# ensure dependencies
dep ensure -v

# set environment variables
export TF_VAR_tenant_id=$ARM_TENANT_ID
export AZURE_TENANT_ID=$AZURE_TENANT_ID
export AZURE_CLIENT_ID=$AZURE_CLIENT_ID
export AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET
export AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID

# run test
go test -v ./test/ -timeout 30m | tee test_output.log
terratest_log_parser -testlog test_output.log -outputdir test_output