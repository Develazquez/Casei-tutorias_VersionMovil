# Resumen del Proyecto: Casei-tutorias_VersionMovil

Este documento detalla la arquitectura, implementación y estado actual de la versión móvil para facilitar la comparación con la versión web.

## 1. Arquitectura y Tecnologías
*   **Framework:** Flutter (SDK ^3.12.0)
*   **Diseño:** Material 3 con Temas dinámicos (Claro/Oscuro).
*   **Patrón de Arquitectura:** Clean Architecture (Capa de Datos, Dominio y Presentación).
*   **Gestión de Estado:** `Provider` para reactividad y Dependency Injection.
*   **Backend:**
    *   **Supabase:** Autenticación (PKCE) y persistencia de datos (Real-time).
    *   **Firebase:** Notificaciones push y mensajería en la nube.
    *   **Microservicio de Segmentación:** API REST propia (`/cacei/segmentation`).

## 2. Funcionalidades Implementadas

### A. Autenticación (`features/auth`)
*   Flujo completo de Login y Registro.
*   **Mejora de UX:** Opción para mostrar/ocultar contraseña en todos los campos de texto sensibles.
*   `AuthChecker` para gestión automática de sesión al inicio.
*   Sincronización global del estado del usuario mediante `AuthProvider`.

### B. Segmentación y Dashboard (`features/segmentation`)
*   **Dashboard V2 (Visor de Solo Lectura):** 
    *   Sincronizado con la lógica de grupos y alcance del tutor (`tutor_student_scope`).
    *   Métricas dinámicas calculadas desde datos reales: Activos, Egresados, Seguimiento Urgente, Generaciones.
    *   Clasificación por perfiles: Crítico, Riesgo, Atípico y Regular.
    *   Visualización de datos: Gráficos de dispersión (PCA), radar de habilidades, distribución de perfiles y asistencia.
*   **Búsqueda Avanzada:**
    *   Búsqueda remota vía API (`GET /search`) con fallback a búsqueda local.
    *   Filtros por texto, generación, perfil académico y baja asistencia.
*   **Machine Learning:**
    *   Sección de detalles del modelo con métricas de calidad y artefactos.

### C. Seguridad (`core/security`)
*   **Simplificación:** Se eliminó la verificación de ubicación (GPS) y el uso de la librería `geolocator` para optimizar el rendimiento y privacidad.
*   `SecurityShell`: Capa protectora que detecta depuración USB activa (USB Debugging) y protege contra capturas de pantalla.
*   Persistencia segura de tokens y credenciales mediante `FlutterSecureStorage`.

## 3. Estado de Sincronización con Web

| Componente | Estado en Móvil | Diferencia con Web (Sincronizado) |
| :--- | :--- | :--- |
| **Lógica de Tutor** | Sincronizada | Usa `tutor_id` para filtrar alumnos y grupos igual que en la versión web. |
| **Filtros de Riesgo** | Umbral 70% | Se ajustó la alerta de baja asistencia al 70% para coincidir con los criterios web. |
| **Mapeo de Datos** | DTOs Robustos | Soporta alias de campos de la API (`id_estudiante`, `matricula`, `period_id`, etc.). |
| **Estatus de Alumnos** | Real | Incluye campos de egreso, semestre y correo institucional. |

## 4. Estados de la Interfaz (Tutor Status)
La aplicación maneja de forma inteligente los estados del tutor para evitar bloqueos:
1.  **NO_GROUP:** Indica que el tutor no tiene grupos asignados por el director.
2.  **NO_DATA:** Grupo asignado pero sin alumnos cargados en el sistema.
3.  **HAS_STUDENTS:** Alumnos disponibles pero procesamiento de segmentación pendiente.
4.  **MODEL_READY:** Funcionamiento normal con todas las métricas.

---
*Archivo actualizado tras la integración de datos reales y optimización de seguridad (Mayo 2024).*
