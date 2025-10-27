# Use an official OpenJDK runtime as a parent image
FROM openjdk:25-jdk

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files to the container
COPY . /app

# Package the application using Maven
RUN ./mvnw clean package

# Run the application
CMD ["java", "-jar", "target/bookfinderproject.jar"]
