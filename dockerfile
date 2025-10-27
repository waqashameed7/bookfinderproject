# Use OpenJDK 25 slim image
FROM openjdk:25-jdk-slim

# Install Maven manually
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy all project files
COPY . /app

# Build the Maven project
RUN mvn clean package

# Copy any JAR in target/ to a standard name
RUN cp target/*.jar app.jar

# Run the application
CMD ["java", "-jar", "app.jar"]
