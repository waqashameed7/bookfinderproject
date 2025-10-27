# Use a Maven + OpenJDK 17 image that exists
FROM maven:3.9.1-openjdk-17

WORKDIR /app
COPY . /app

RUN mvn clean package

CMD ["java", "-jar", "target/your-app-name.jar"]
