FROM openjdk:8-jre-alpine 
WORKDIR /app 
COPY ./target/test-single-mvn-demo-1.0-SNAPSHOT.jar /app/

ENTRYPOINT []
CMD ["java", "-jar", "/app/test-single-mvn-demo-1.0-SNAPSHOT.jar"]