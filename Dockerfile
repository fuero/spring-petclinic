FROM docker.io/library/openjdk:21-jdk-slim
COPY --chmod=0644 target/*.jar /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
