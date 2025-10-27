# Use CircleCI's OpenJDK 25 image with Maven pre-installed
FROM cimg/openjdk:25.0.0

# Set the working directory inside the container
WORKDIR /app

# Copy your project files into the container
COPY . /app

# Package the application using Maven
RUN mvn clean package

# Run the application
CMD ["java", "-jar", "target/your-app-name.jar"]
