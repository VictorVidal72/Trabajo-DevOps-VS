# =========================================================================
# Dockerfile - Entorno Flutter para CI/CD local
# =========================================================================
# Este Dockerfile permite simular un entorno de CI similar a Codemagic
# para desarrollo y testing local.
#
# Uso:
#   docker build -t flutter-ci .
#   docker run --rm -v $(pwd):/app flutter-ci flutter test
# =========================================================================

FROM ghcr.io/cirruslabs/flutter:stable

LABEL maintainer="Víctor Vidal & Mario Escobar"
LABEL description="Entorno Flutter CI para desarrollo local "

# Establecer directorio de trabajo
WORKDIR /app

# Variables de entorno
ENV PUB_CACHE="/root/.pub-cache"
ENV FLUTTER_HOME="/sdks/flutter"

# Copiar ficheros de configuración primero (mejor uso de caché)
COPY pubspec.* ./

# Obtener dependencias (se cachean si pubspec no cambia)
RUN flutter pub get

# Copiar resto del proyecto
COPY . .

# Comandos por defecto
CMD ["flutter", "test", "--coverage"]

# =========================================================================
# Comandos útiles:
# =========================================================================
# 
# Construir imagen:
#   docker build -t flutter-ci .
#
# Ejecutar tests:
#   docker run --rm flutter-ci
#
# Ejecutar análisis:
#   docker run --rm flutter-ci flutter analyze
#
# Build APK:
#   docker run --rm -v $(pwd)/build:/app/build flutter-ci flutter build apk
#
# Shell interactivo:
#   docker run -it --rm flutter-ci /bin/bash
# =========================================================================
