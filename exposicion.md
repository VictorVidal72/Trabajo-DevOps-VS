# Esqueleto para la Presentación de Codemagic (CI/CD)
**Integrantes:** Víctor Manuel Vidal Molina & Mario Escobar Vidal

---

## Diapositiva 1: Introducción y Definición
* **Herramienta elegida:** Codemagic (Plataforma SaaS de CI/CD para Mobile).
* **¿Qué es?**: Un servicio en la nube que automatiza la construcción, testeo y despliegue de Apps.
* **Concepto DevOps:** Implementación de **Infraestructura como Código (IaC)** mediante ficheros YAML para eliminar procesos manuales y errores humanos.

## Diapositiva 2: El Reto Técnico (Estructura del Proyecto)
* **Contexto:** El código de la App no estaba en la raíz, sino en la carpeta `/demo_app`.
* **Problema inicial:** Los primeros intentos de build fallaron porque el pipeline no encontraba el archivo `pubspec.yaml` (Error de directorio).
* **Solución:** Configuración del parámetro `working_directory: demo_app` en el pipeline para dirigir correctamente las operaciones de Flutter.

## Diapositiva 3: Arquitectura del Pipeline (codemagic.yaml)
* **Entorno:** Ejecución sobre máquinas virtuales **Mac mini M2** (garantía de rendimiento).
* **Fases del Workflow (Puntos clave para explicar):**
    1.  **Triggers:** Activación automática mediante Webhooks al hacer `push` o `PR` en GitHub.
    2.  **Scripts de Validación:**
        * `flutter pub get`: Instalación de dependencias.
        * `flutter analyze`: Análisis estático del código (Linting).
        * `flutter test`: Ejecución de tests unitarios automáticos.
    3.  **Build:** Generación del binario ejecutable (.apk).

## Diapositiva 4: Evidencias de Éxito (Cloud)
* **Resultado:** Pipeline finalizado con estado "Finished" con éxito.
* **Tiempos:** Demostración de eficiencia (Build total en ~3m 30s).
* **Artefactos:** Generación real de la aplicación `app-debug.apk` (136.39 MB) descargable desde la plataforma.

## Diapositiva 5: Herramienta Adicional - Docker (IaC Local)
* **¿Por qué Docker?**: Para garantizar la paridad entre el entorno local del desarrollador y el entorno de CI/CD en la nube.
* **Implementación:**
    * Creación de un `Dockerfile` con el SDK de Flutter estable.
    * **Validación Local:** Ejecución de `docker run` que descarga dependencias y pasa los tests automáticamente.
* **Ventaja DevOps:** Permite validar cambios "pesados" sin consumir minutos de build en la nube.

## Diapositiva 6: Conclusiones y Estructura de Entrega
* **Ubicación en el Repo:** Carpeta `tools/codemagic/` conteniendo:
    * `codemagic.yaml` (Pipeline nube).
    * `Dockerfile` (Entorno local).
    * `README.md` (Documentación técnica completa).
* **Logro:** Pipeline 100% funcional desde el commit hasta el artefacto final.

---

### Notas para el presentador (Trucos de la rúbrica):
* **Punto extra:** Enfatizar que el uso de Docker cuenta como "herramienta adicional" para mejorar la explicación del despliegue.
* **Fluidez:** Al hablar del `working_directory`, mencionad que es un ajuste común en proyectos monorepo, demostrando conocimiento profesional.