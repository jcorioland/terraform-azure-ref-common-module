#!/bin/bash

set -e

# ensure dependencies
dep ensure

# set environment variables
export TF_VAR_tenant_id=$ARM_TENANT_ID

# run test
go test -v ./test/ -timeout 30m | tee test_output.log
terratest_log_parser -testlog test_output.log -outputdir test_output