### Maven Proxy Settings
-------------
```
<proxies>
    <proxy>
      <active>true</active>
      <protocol>http</protocol>
      <host>proxy01.dev.local</host>
      <port>3128</port>
    </proxy>
  </proxies>
```

### Maven
-------------
```
mvn clean -f ./pom.xml
mvn install -f ./pom.xml
mvn package -f ./pom.xml
```

### Java
-------------
```
java -jar .\target\test-single-mvn-demo-1.0-SNAPSHOT.jar
```

### Docker
-------------
```
#ロカールテストする場合、dockerへMaven Proxy設定が必要です。
docker build . -t test-single-mvn-demo
docker images
docker run test-single-mvn-demo
```

### dockfile
-------------
```
FROM openjdk:8-jre-alpine 
WORKDIR /app 
COPY ./target/test-single-mvn-demo-1.0-SNAPSHOT.jar /app/

ENTRYPOINT []
CMD ["java", "-jar", "/app/test-single-mvn-demo-1.0-SNAPSHOT.jar"]
```

### buildspec.yml
-------------
```
version: 0.2
phases:
  pre_build:
    commands:
      - echo mvn started on `date`
      - mvn install
      - echo pre_build started on `date`
      - REPOSITORY_URI=(〇〇〇)
      - aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $REPOSITORY_URI
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
  build:
    commands:
      - echo build started on `date`
      - docker build -t $REPOSITORY_URI:latest .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
  post_build:
    commands:
      - echo post_build started on `date`
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - printf '[{"name":"test-single-mvn-demo","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json
artifacts:
    files: imagedefinitions.json
```

