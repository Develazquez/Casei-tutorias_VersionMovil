# Resumen del Proyecto: Casei-tutorias_VersionMovil

Este documento detalla la arquitectura, implementación y estado actual de la versión móvil para facilitar la comparación con la versión web.

## 1. Arquitectura y Tecnologías
*   **Framework:** Flutter (SDK ^3.12.0)
*   **Diseño:** Material 3 con Temas dinámicos (Claro/Oscuro).
*   **Patrón de Arquitectura:** Clean Architecture (Capa de Datos, Dominio y Presentación).
*   **Gestión de Estado:** `Provider` para reactividad y Dependency Injection simple.
*   **Backend:**
    *   **Supabase:** Autenticación (PKCE) y persistencia de datos.
    *   **Firebase:** Notificaciones push y mensajería en la nube.
*   **Navegación:** Basada en rutas predefinidas y un `TutorNavigationDrawer`.

## 2. Funcionalidades Implementadas

### A. Autenticación (`features/auth`)
*   Flujo completo de Login y Registro.
*   `AuthChecker` para gestión automática de sesión al inicio.
*   Sincronización global del estado del usuario mediante `AuthProvider`.

### B. Segmentación y Dashboard (`features/segmentation`)
*   **Dashboard V2:** 
    *   Métricas clave (Activos, Egresados, Seguimiento Urgente, Generaciones).
    *   Clasificación por perfiles: Crítico, Riesgo, Atípico y Regular.
    *   Visualización de datos: Gráficos de dispersión (PCA), radar de habilidades, distribución de perfiles y asistencia.
*   **Búsqueda Avanzada:**
    *   Filtros por texto, generación, perfil académico y baja asistencia.
    *   Lógica de normalización de texto y priorización de alumnos críticos.
*   **Machine Learning:**
    *   Sección de detalles del modelo con métricas de calidad y artefactos.

### C. Seguridad (`core/security`)
*   `SecurityShell`: Capa protectora que envuelve la app para detectar:
    *   Depuración USB activa (USB Debugging).
    *   Ubicaciones falsas (Mock GPS).
*   Persistencia segura de tokens y credenciales mediante `FlutterSecureStorage`.

## 3. Estado de Sincronización con Web

| Componente | Estado en Móvil | Diferencia con Web (Potencial) |
| :--- | :--- | :--- |
| **Modelos de Datos** | `SegmentationStudentEntity` | En `SearchTutoradosUseCase` se menciona que el filtro de **alumni (egresados)** aún no está disponible en la entidad real. |
| **Versión UI** | Dashboard V2 | Es necesario confirmar si Web ya opera sobre una V3 o tiene componentes adicionales de visualización. |
| **Filtros** | Básicos + Prioridad | Web suele tener mayor granularidad en filtros académicos. |
| **Gráficos** | Radar, PCA, Barras | Verificar si las constantes de colores y umbrales (ej. 60% asistencia) coinciden con los de Web. |

## 4. Áreas de Oportunidad / Desactualización
1.  **Entidad de Estudiante:** Falta el campo o lógica real para identificar egresados (`alumniOnly`).
2.  **Modo de Datos:** El sistema alterna entre datos reales y mocks; asegurar que los campos de la API de Supabase en Web coincidan 1:1 con los DTOs móviles.
3.  **Lógica de Negocio:** El umbral de baja asistencia está hardcodeado en `60.0` dentro del Use Case móvil. Validar si esto es configurable o diferente en Web.

---
*Archivo generado para auditoría de sincronización entre plataformas.*
