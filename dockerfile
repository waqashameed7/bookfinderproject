# Use Maven with OpenJDK 21
FROM maven:3.9.1-openjdk-21

WORKDIR /app
COPY . /app

# Package the project
RUN mvn clean package

# Run the app
CMD ["java", "-jar", "target/your-app-name.jar"]
