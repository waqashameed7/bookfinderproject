FROM maven:3.9.1-openjdk-25

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Package the project
RUN mvn clean package

# Run the app
CMD ["java", "-jar", "target/your-app-name.jar"]
