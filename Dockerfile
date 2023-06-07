FROM maven:3.8.7-openjdk-18-slim AS builder

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
ENV AWS_REGION eu-west-1

ENV VERSION 1.0.0

WORKDIR /usr/src/app/modules/kafka-ext

COPY . /usr/src/app
RUN mvn -Dmaven.test.skip=true -Dmaven.javadoc.skip=true package

RUN apt-get update && apt-get install -y awscli
RUN aws s3 cp /usr/src/app/modules/kafka-ext/target/ignite-kafka-ext-$VERSION-SNAPSHOT.jar s3://artifactory.naga.com/releases/org/apache/ignite/stream/kafka/connect/$VERSION/ignite-kafka-ext-$VERSION.jar

