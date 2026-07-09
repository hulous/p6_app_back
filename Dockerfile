FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /home/app

# Copy Gradle wrapper and build files first for cache efficiency
COPY gradle gradle
COPY gradlew .
COPY build.gradle settings.gradle gradle.properties ./

# Copy sources and build the jar
COPY src ./src
RUN chmod +x ./gradlew && ./gradlew bootJar --no-daemon -Dorg.gradle.java.home="$(dirname $(dirname $(readlink -f $(which java))))"

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=builder /home/app/build/libs/*.jar ./app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
