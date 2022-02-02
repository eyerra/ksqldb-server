ARG DOCKER_UPSTREAM_REGISTRY
ARG DOCKER_UPSTREAM_TAG

FROM ${DOCKER_UPSTREAM_REGISTRY}confluentinc/cp-base-new:${DOCKER_UPSTREAM_TAG}

ARG PROJECT_VERSION
ARG ARTIFACT_ID

ENV AWS_MSK_IAM_AUTH="1.1.1"

USER root

# target directory must be one of the projects that ksql-run-class sets on the KSQL_CLASSPATH,
# of which the artifact ID (ksqldb-docker) is not one. thus the workaround of using ksqldb-rest-app
ADD --chown=appuser:appuser target/${ARTIFACT_ID}-${PROJECT_VERSION}-package/share/java/${ARTIFACT_ID}/* /usr/share/java/ksqldb-rest-app/
ADD --chown=appuser:appuser target/${ARTIFACT_ID}-${PROJECT_VERSION}-package/bin/* /usr/bin/
ADD --chown=appuser:appuser target/${ARTIFACT_ID}-${PROJECT_VERSION}-package/bin/docker/* /usr/bin/docker/
ADD --chown=appuser:appuser target/${ARTIFACT_ID}-${PROJECT_VERSION}-package/etc/* /etc/ksqldb/
ADD --chown=appuser:appuser target/${ARTIFACT_ID}-${PROJECT_VERSION}-package/share/doc/* /usr/share/doc/${ARTIFACT_ID}/

RUN wget https://github.com/aws/aws-msk-iam-auth/releases/download/v$AWS_MSK_IAM_AUTH/aws-msk-iam-auth-$AWS_MSK_IAM_AUTH-all.jar \
    && mv aws-msk-iam-auth-$AWS_MSK_IAM_AUTH-all.jar /usr/share/java/ksqldb-rest-app/

RUN echo "===> Installing confluent-hub..." \
    && wget http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz \
    && tar xf confluent-hub-client-latest.tar.gz \
    && rm confluent-hub-client-latest.tar.gz

RUN chmod +x /usr/bin/docker/configure
RUN chmod +x /usr/bin/docker/run

USER appuser

CMD ["/usr/bin/docker/run"]