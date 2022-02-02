#!/bin/bash

git clone https://github.com/confluentinc/ksql.git


mv Dockerfile ksql/ksqldb-docker

cd ksql/ksqldb-docker
mvn clean
mvn -U -Pdocker package -DskipTests -Dspotbugs.skip -Dcheckstyle.skip  -Ddockerfile.skip=false -Dskip.docker.build=false -Ddocker.upstream-tag=latest-ubi8 -Ddocker.tag=local.build  -Ddocker.upstream-registry=''
