# declaration of NEXUS_VERSION must appear before first FROM command
# see: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG NEXUS_VERSION=latest

FROM skaz5zzd.mirror.aliyuncs.com/maven:3-jdk-8-alpine AS build

COPY . /nexus-repository-apk/
RUN cd /nexus-repository-apk/; \
    mvn clean package -PbuildKar;

FROM skaz5zzd.mirror.aliyuncs.com/sonatype/nexus3:$NEXUS_VERSION

ARG FORMAT_VERSION=0.0.5-SNAPSHOT
ARG DEPLOY_DIR=/opt/sonatype/nexus/deploy/
USER root
COPY --from=build /nexus-repository-apk/nexus-repository-apk/target/nexus-repository-apk-${FORMAT_VERSION}-bundle.kar ${DEPLOY_DIR}
USER nexus
