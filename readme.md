# Codemagic – Herramienta DevOps CI/CD

## Índice
- [Introducción](#introducción)
- [Características principales](#características-principales)
- [Cómo funciona Codemagic](#cómo-funciona-codemagic)
- [Guía de despliegue](#guía-de-despliegue)
- [Pipeline de ejemplo](#pipeline-de-ejemplo)
- [Cómo ejecutar el pipeline](#cómo-ejecutar-el-pipeline)
- [Opciones de despliegue](#opciones-de-despliegue)
- [Recursos adicionales](#recursos-adicionales)

---

## Introducción.

**Codemagic** es una plataforma de **Integración Continua y Entrega Continua (CI/CD)** especializada principalmente en proyectos **Flutter, Android, iOS y aplicaciones multiplataforma**. Permite automatizar procesos como la compilación, ejecución de tests, generación de artefactos y despliegue de aplicaciones sin necesidad de mantener infraestructura propia.

Codemagic está orientada a flujos de trabajo declarativos mediante ficheros **YAML**, lo que facilita la adopción de prácticas DevOps como:
- **Integración Continua (CI)**: Compilación y testing automático en cada commit
- **Entrega Continua (CD)**: Despliegue automatizado a tiendas de aplicaciones
- **Automatización de pipelines**: Flujos de trabajo personalizables
- **Infraestructura como Código (IaC)**: Configuración declarativa mediante `codemagic.yaml`

La herramienta se integra de forma nativa con repositorios **GitHub**, **GitLab**, **Bitbucket** y **Azure DevOps**, y ofrece ejecución de pipelines en contenedores gestionados por la propia plataforma.

---

## Características principales

| Característica | Descripción |
|---|---|
| **Multi-plataforma** | Build para iOS, Android, Web, macOS y Windows desde un único workflow |
| **Zero-Config Builds** | Conexión rápida de proyectos Flutter sin configuración inicial |
| **Fichero codemagic.yaml** | Definición declarativa de pipelines CI/CD |
| **Máquinas de build potentes** | macOS (incluyendo Apple Silicon) y Linux |
| **Testing automatizado** | Tests unitarios, widget tests y UI tests (Flutter Driver) |
| **Code Signing** | Firma automática para iOS (App Store) y Android |
| **Variables de entorno** | Gestión segura de secretos y credenciales |
| **Build Triggers** | Activación por push, pull request o tags |
| **Cacheo de dependencias** | Aceleración de builds mediante caché |
| **Publicación** | Despliegue directo a Google Play, App Store y TestFlight |

---

## Cómo funciona Codemagic

```
┌─────────────────────────────────────────────────────────────────┐
│                         FLUJO CI/CD                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────┐    ┌──────────────┐    ┌─────────────────┐       │
│   │  Código  │───▶│  Codemagic   │───▶│   Artefactos    │       │
│   │  (Git)   │    │  (CI/CD)     │    │   (.apk/.ipa)   │       │
│   └──────────┘    └──────────────┘    └─────────────────┘       │
│        │                │                      │                 │
│        │                ▼                      ▼                 │
│        │         ┌──────────────┐    ┌─────────────────┐        │
│   Push/PR        │    Tests     │    │   Despliegue    │        │
│                  │  Unitarios   │    │  Play/App Store │        │
│                  └──────────────┘    └─────────────────┘        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Proceso típico:
1. **Trigger**: Un evento Git (push, PR) activa el pipeline
2. **Build**: Codemagic compila la aplicación en sus máquinas cloud
3. **Test**: Se ejecutan los tests configurados
4. **Artefactos**: Se generan los binarios (.apk, .aab, .ipa)
5. **Deploy**: Publicación automática a tiendas de apps

---

## Guía de despliegue

Codemagic es un servicio **SaaS** (Software as a Service), por lo que no requiere instalación local. El "despliegue" consiste en configurar el servicio cloud.

### Opción 1: Usar Codemagic Cloud (Recomendado)

#### Paso 1: Crear cuenta
1. Acceder a [codemagic.io](https://codemagic.io)
2. Hacer clic en **"Start building"** o **"Sign up"**
3. Autenticarse con GitHub, GitLab, Bitbucket o email

#### Paso 2: Conectar repositorio
1. En el dashboard, hacer clic en **"Add application"**
2. Seleccionar el proveedor Git (GitHub, GitLab, Bitbucket)
3. Autorizar el acceso a Codemagic
4. Seleccionar el repositorio del proyecto

#### Paso 3: Configurar el proyecto
1. Codemagic detectará automáticamente el tipo de proyecto (Flutter, React Native, etc.)
2. Puedes usar el **Workflow Editor** (GUI) o crear un fichero `codemagic.yaml`
3. Configurar variables de entorno si es necesario

#### Paso 4: Ejecutar primer build
1. Hacer clic en **"Start new build"**
2. Seleccionar la rama y el workflow
3. Monitorizar el progreso en el dashboard

### Opción 2: Usar Codemagic CLI (Local)

Codemagic ofrece un CLI para ejecutar builds localmente (útil para testing):

```bash
# Instalar Codemagic CLI
pip install codemagic-cli-tools

# Verificar instalación
codemagic-cli-tools --version

# Comandos disponibles
keychain              # Gestión de keychains para iOS
app-store-connect     # Integración con App Store Connect
google-play           # Integración con Google Play
```

### Opción 3: Entorno Docker para desarrollo local

Para simular un entorno de CI/CD localmente, puedes usar Docker con Flutter:

```dockerfile
# Dockerfile para entorno Flutter
FROM cirrusci/flutter:stable

WORKDIR /app

# Copiar proyecto
COPY . .

# Instalar dependencias
RUN flutter pub get

# Ejecutar tests
CMD ["flutter", "test"]
```

```bash
# Construir imagen
docker build -t flutter-ci .

# Ejecutar tests
docker run --rm flutter-ci
```

---

## Pipeline de ejemplo

El pipeline se define en el fichero `codemagic.yaml` ubicado en la raíz del repositorio.

### Estructura del fichero

```yaml
# codemagic.yaml - Pipeline CI/CD para Flutter

workflows:
  flutter-workflow:
    name: Flutter CI/CD Pipeline
    max_build_duration: 60
    
    environment:
      flutter: stable
      xcode: latest
      
    triggering:
      events:
        - push
        - pull_request
      branch_patterns:
        - pattern: 'main'
          include: true
        - pattern: 'develop'
          include: true
          
    scripts:
      - name: Obtener dependencias
        script: flutter pub get
        
      - name: Analizar código
        script: flutter analyze
        
      - name: Ejecutar tests unitarios
        script: flutter test --coverage
        
      - name: Build Android APK
        script: flutter build apk --release
        
      - name: Build Android App Bundle
        script: flutter build appbundle --release
        
    artifacts:
      - build/**/outputs/**/*.apk
      - build/**/outputs/**/*.aab
      - coverage/lcov.info
      
    publishing:
      email:
        recipients:
          - dev@example.com
        notify:
          success: true
          failure: true
```

➡️ **Ver el fichero completo**: [codemagic.yaml](./codemagic.yaml)

---

## Cómo ejecutar el pipeline

### Prerrequisitos
- Cuenta en [Codemagic](https://codemagic.io)
- Repositorio Git con proyecto Flutter
- Fichero `codemagic.yaml` en la raíz del repositorio

### Paso 1: Preparar el repositorio

```bash
# Clonar/crear proyecto Flutter
flutter create mi_app
cd mi_app

# Copiar el fichero codemagic.yaml a la raíz
# (usar el ejemplo proporcionado o personalizarlo)

# Commit y push
git add codemagic.yaml
git commit -m "ci: añadir configuración Codemagic"
git push origin main
```

### Paso 2: Conectar con Codemagic

1. Iniciar sesión en [codemagic.io](https://codemagic.io)
2. Hacer clic en **"Add application"**
3. Seleccionar el repositorio
4. Codemagic detectará automáticamente el `codemagic.yaml`

### Paso 3: Ejecutar build manualmente

1. En el dashboard, seleccionar el proyecto
2. Hacer clic en **"Start new build"**
3. Seleccionar rama (ej: `main`) y workflow
4. Hacer clic en **"Start new build"**

### Paso 4: Monitorizar ejecución

- Ver logs en tiempo real de cada step
- Descargar artefactos generados (.apk, .aab)
- Revisar resultados de tests
- Recibir notificaciones por email

### Ejecución automática (Triggers)

El pipeline se ejecutará automáticamente cuando:
- Se haga **push** a las ramas `main` o `develop`
- Se abra o actualice un **Pull Request**

---

## Opciones de despliegue

### Google Play Store

```yaml
publishing:
  google_play:
    credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
    track: internal  # internal, alpha, beta, production
    submit_as_draft: true
```

### Apple App Store / TestFlight

```yaml
publishing:
  app_store_connect:
    api_key: $APP_STORE_CONNECT_PRIVATE_KEY
    key_id: $APP_STORE_CONNECT_KEY_ID
    issuer_id: $APP_STORE_CONNECT_ISSUER_ID
    submit_to_testflight: true
```

### Firebase App Distribution

```yaml
publishing:
  firebase:
    firebase_token: $FIREBASE_TOKEN
    app_id: com.example.app
    groups:
      - qa-team
```

---

## Recursos adicionales

- 📚 [Documentación oficial](https://docs.codemagic.io/)
- 🎓 [Codemagic Blog](https://blog.codemagic.io/)
- 📝 [Ejemplos de codemagic.yaml](https://github.com/codemagic-ci-cd/codemagic-sample-projects)
- 💬 [Comunidad Slack](https://slack.codemagic.io/)
- 🎥 [Canal de YouTube](https://www.youtube.com/c/Codemagic)

---

## Autores

| Nombre | GitHub |
|--------|--------|
| Vidal Molina, Víctor Manuel | [@VictorVidal72](https://github.com/VictorVidal72) |
| Escobar Vidal, Mario | [@Mariio711](https://github.com/Mariio711) |
