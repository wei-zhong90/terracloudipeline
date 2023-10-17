############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder
# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

# Configure all necessary certificates
RUN apk --no-cache add ca-certificates
WORKDIR $GOPATH/src/mypackage/myapp/
COPY . .
# Fetch dependencies.
# Using go get.
RUN go get -d -v
# Build the binary.
RUN go build -o /go/bin/workspaceutils
############################
# STEP 2 build a small image
############################
FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/workspaceutils /go/bin/workspaceutils
COPY --from=builder /etc/ssl /etc/ssl
# Run the binary.
ENTRYPOINT ["/go/bin/workspaceutils"]