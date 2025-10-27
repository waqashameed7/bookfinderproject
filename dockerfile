FROM openjdk:21-jdk-slim

WORKDIR /app
COPY . /app

# Install Maven
RUN apt-get update && apt-get install -y maven

RUN mvn clean package
CMD ["java", "-jar", "target/your-app-name.jar"]
