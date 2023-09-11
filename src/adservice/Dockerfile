# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0


FROM eclipse-temurin:17-jdk AS builder

WORKDIR /usr/src/

RUN apt-get update && apt-get install unzip

RUN curl -L https://github.com/jack-berg/opentelemetry-java-contrib/archive/refs/heads/local-trace-batch-processor.zip --output contrib.zip \
     && unzip contrib.zip \
     && mv opentelemetry-java-contrib-local-trace-batch-processor ./contrib \
     && cd contrib \
     && ./gradlew :processors:assemble

WORKDIR /usr/src/app/

COPY ./src/adservice/gradlew* ./src/adservice/settings.gradle* ./src/adservice/build.gradle .
COPY ./src/adservice/gradle ./gradle

RUN ./gradlew
RUN ./gradlew downloadRepos

COPY ./src/adservice/ ./
COPY ./pb/ ./proto
RUN ./gradlew installDist -PprotoSourceDir=./proto

# -----------------------------------------------------------------------------

FROM eclipse-temurin:17-jre

ARG version=1.28.0
WORKDIR /usr/src/app/

COPY --from=builder /usr/src/app/ ./
COPY --from=builder /usr/src/contrib/processors/build/libs/local-trace-batch-processor.jar ./local-trace-batch-processor.jar
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v$version/opentelemetry-javaagent.jar /usr/src/app/opentelemetry-javaagent.jar
RUN chmod 644 /usr/src/app/opentelemetry-javaagent.jar
ENV JAVA_TOOL_OPTIONS="-javaagent:/usr/src/app/opentelemetry-javaagent.jar -Dotel.javaagent.extensions=/usr/src/app/local-trace-batch-processor.jar"

EXPOSE ${AD_SERVICE_PORT}
ENTRYPOINT [ "./build/install/opentelemetry-demo-ad-service/bin/AdService" ]
