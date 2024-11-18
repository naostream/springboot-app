# Étape 1 : Utiliser une image de base avec Java 21
FROM openjdk:21-jdk-slim AS build

# Étape 2 : Installer Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean

# Étape 3 : Définir le répertoire de travail
WORKDIR /app

# Étape 4 : Copier le fichier pom.xml et le fichier de dépendances
COPY pom.xml .

# Installer les dépendances
RUN mvn dependency:go-offline

# Étape 5 : Copier le code source de l'application
COPY src ./src

# Étape 6 : Construire l'application
RUN mvn package -DskipTests

# Étape 7 : Étape finale : exécuter le JAR
FROM openjdk:21-jdk-slim
VOLUME /tmp
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar demo-0.0.1-SNAPSHOT.jar
EXPOSE 8090
ENTRYPOINT ["java", "-jar", "demo-0.0.1-SNAPSHOT.jar"]