#*******************************************************************************
# Licensed Materials - Property of IBM
# "Restricted Materials of IBM"
# 
# Copyright IBM Corp. 2018 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#*******************************************************************************

# We're only using this layer to build so no need to lock it down any more than this (with the tag).
FROM golang:1.11 as builder

WORKDIR /go/src/github.ibm.com/dev-ex/che-test-service/
COPY . .

# Install Dep and  down any dependencies and build the app
# Uncomment once external depedencies are needed and a Gopkg.toml is present
#RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
#RUN dep ensure -v

# Build the app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# This alpine SHA maps to version 3.7, which is the latest we've tested with at the time of this change.
FROM alpine@sha256:7df6db5aa61ae9480f52f0b3a06a140ab98d427f86d8d5de0bedab9b8df6b1c0
RUN apk --no-cache add bash ca-certificates git

WORKDIR /root

# Copy the app and the scripts over from the build container
COPY --from=builder /go/src/github.ibm.com/dev-ex/che-test-service/app .
COPY --from=builder /go/src/github.ibm.com/dev-ex/che-test-service/scripts /scripts
RUN chmod -R +x /scripts
RUN chmod -R +x /root

EXPOSE 8080
ENTRYPOINT ["/scripts/entrypoint.sh"]