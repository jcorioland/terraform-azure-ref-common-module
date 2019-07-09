FROM jcorioland/azure-terratest:0.12.3

# Define environment variables
ARG BUILD_MODULE_NAME="common-module"
ENV MODULE_NAME=${BUILD_MODULE_NAME}

# Set work directory.
RUN mkdir /go/src/${MODULE_NAME}
COPY . /go/src/${MODULE_NAME}
WORKDIR /go/src/${MODULE_NAME}

RUN chmod +x run-tests.sh

ENTRYPOINT [ "./run-tests.sh" ]