# Builder image
FROM golang:1.11-alpine3.8 as builder
MAINTAINER Tom Kirkpatrick <tkp@kirkdesigns.co.uk>

# Add build tools.
RUN apk --no-cache --virtual build-dependencies add \
	build-base \
	git


WORKDIR $GOPATH/src/github.com/btcsuite/btcd

# Grab and install the latest version of btcd and all related dependencies.
RUN git clone https://github.com/btcsuite/btcd . \
  && git reset --hard ed77733ec07dfc8a513741138419b8d9d3de9d2d \
	&&  GO111MODULE=on go install -v . ./cmd/...

# Final image
FROM alpine:3.8 as final
MAINTAINER Tom Kirkpatrick <tkp@kirkdesigns.co.uk>

# Add utils.
RUN apk --no-cache add \
	bash \
	su-exec \
	ca-certificates \
	&& update-ca-certificates

ARG USER_ID
ARG GROUP_ID

ENV HOME /btcd

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -g ${GROUP_ID} -S btcd && \
  adduser -u ${USER_ID} -S btcd -G btcd -s /bin/bash -h /btcd btcd

# Copy the compiled binaries from the builder image.
COPY --from=builder /go/bin/addblock /bin/
COPY --from=builder /go/bin/btcctl /bin/
COPY --from=builder /go/bin/btcd /bin/
COPY --from=builder /go/bin/findcheckpoint /bin/
COPY --from=builder /go/bin/gencerts /bin/

ADD ./bin /usr/local/bin

# Create a volume to house btcd data
VOLUME ["/btcd"]

# Expose mainnet ports (server, rpc)
EXPOSE 8333 8334

# Expose testnet ports (server, rpc)
EXPOSE 18333 18334

# Expose simnet ports (server, rpc)
EXPOSE 18555 18556

# Expose segnet ports (server, rpc)
EXPOSE 28901 28902

WORKDIR /btcd

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["btcd_oneshot"]
