FROM openjdk:25-jdk-slim

# Install Maven manually
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN mvn clean package
CMD ["java", "-jar", "target/book-finder-0.0.1-SNAPSHOT.jar"]
# Copy built JAR to a standard name
COPY target/*.jar app.jar

CMD ["java", "-jar", "app.jar"]


