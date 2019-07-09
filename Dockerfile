FROM golang:1.12.6

# Define environment variables
ARG BUILD_TERRAFORM_VERSION="0.12.3"
ARG BUILD_MODULE_NAME="common-module"
ARG BUILD_TERRAFORM_OS_ARCH=linux_amd64
ARG BUILD_TERRATEST_LOG_PARSER_VERSION="v0.17.5"

ENV TERRAFORM_VERSION=${BUILD_TERRAFORM_VERSION}
ENV TERRAFORM_OS_ARCH=${BUILD_TERRAFORM_OS_ARCH}
ENV MODULE_NAME=${BUILD_MODULE_NAME}
ENV TERRATEST_LOG_PARSER_VERSION=${BUILD_TERRATEST_LOG_PARSER_VERSION}

# Update & Install tool
RUN apt-get update && \
    apt-get install -y build-essential unzip

# Install dep.
ENV GOPATH /go
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH
RUN /bin/bash -c "curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh"

# Install Terraform
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS_ARCH}.zip && \
    curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    curl -s https://keybase.io/hashicorp/pgp_keys.asc | gpg --import && \
    curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig && \
    gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    shasum -a 256 -c terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1 | grep "${TERRAFORM_VERSION}_${TERRAFORM_OS_ARCH}.zip:\sOK" && \
    unzip -o terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS_ARCH}.zip -d /usr/local/bin

# Cleanup
RUN rm terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS_ARCH}.zip
RUN rm terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN rm terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig

# Install Terratest Log Parser
RUN curl -OLs https://github.com/gruntwork-io/terratest/releases/download/${TERRATEST_LOG_PARSER_VERSION}/terratest_log_parser_${TERRAFORM_OS_ARCH} && \
    chmod +x terratest_log_parser_${TERRAFORM_OS_ARCH} && \
    mv terratest_log_parser_${TERRAFORM_OS_ARCH} /usr/local/bin/terratest_log_parser

RUN mkdir ~/.ssh
RUN ssh-keygen -b 2048 -t rsa -f ~/.ssh/test_rsa -q -N ""

# Set work directory.
RUN mkdir /go/src/${MODULE_NAME}
COPY . /go/src/${MODULE_NAME}
WORKDIR /go/src/${MODULE_NAME}

RUN chmod +x run-tests.sh

ENTRYPOINT [ "./run-tests.sh" ]