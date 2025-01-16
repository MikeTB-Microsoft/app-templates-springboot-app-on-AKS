# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the executable JAR file to the container
COPY target/my-spring-boot-app.jar /app/my-spring-boot-app.jar

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/app/my-spring-boot-app.jar"]
