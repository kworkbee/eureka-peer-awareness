FROM --platform=${BUILDPLATFORM} openjdk:17.0.2 AS build

ARG BUILDPLATFORM
ENV APP_HOME=/usr/app
WORKDIR ${APP_HOME}

COPY gradlew build.gradle settings.gradle ./
COPY gradle/ gradle/
COPY src/ src/

RUN microdnf install findutils
RUN ./gradlew bootJar

FROM openjdk:17.0.2

ENV APP_HOME=/usr/app
WORKDIR ${APP_HOME}

ARG JAR_FILE_NAME=eureka-server-0.0.1-SNAPSHOT.jar
ARG JAR_FILE=build/libs/${JAR_FILE_NAME}

COPY --from=build ${APP_HOME}/${JAR_FILE} ${JAR_FILE_NAME}

# FOR PEER1
EXPOSE 3001
ENTRYPOINT ["java", "-Dspring.profile.active=peer1", "-jar", "eureka-server-0.0.1-SNAPSHOT.jar"]