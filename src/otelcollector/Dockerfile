FROM golang:1.20 as builder

WORKDIR /builder
COPY builder .
RUN CGO_ENABLED=0 GOOS=linux make

FROM scratch

ARG USER_UID=10001
USER ${USER_UID}

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder --chmod=755 /builder/distributions/nrdemocol/_build/nrdemocol /nrdemocol

ENTRYPOINT ["/nrdemocol"]
EXPOSE 4317
