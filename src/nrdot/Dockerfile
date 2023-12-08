FROM golang:1.20 as builder

WORKDIR /builder
COPY ./src/nrdot/builder .
RUN CGO_ENABLED=0 GOOS=linux make

FROM scratch

ARG USER_UID=10001
USER ${USER_UID}

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder --chmod=755 /builder/distributions/nrdot/_build/nrdot /nrdot

ENTRYPOINT ["/nrdot"]
EXPOSE 4317
