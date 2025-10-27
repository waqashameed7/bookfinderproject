# ===== Build stage =====
FROM maven:3.9.9-eclipse-temurin-25 AS build

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Package the application without running tests
RUN mvn clean package -DskipTests

# ===== Runtime stage =====
FROM openjdk:25-jdk

# Set working directory for the runtime container
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port (optional, if you know it)
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
