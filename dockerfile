# Use a stable OpenJDK image
FROM openjdk:17-jdk-slim

# Install Maven and other required tools
RUN apt-get update && \
    apt-get install -y maven git && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Build the project
RUN mvn clean package

# Run the application
CMD ["java", "-jar", "target/your-app-name.jar"]
