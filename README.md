# 🏦 NUTRIA — Laboratorio Oracle PL/SQL

<p align="center">

![Oracle](https://img.shields.io/badge/Oracle-Database-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-Development-blue?style=for-the-badge)
![Java](https://img.shields.io/badge/Java-Spring%20Boot-orange?style=for-the-badge&logo=springboot&logoColor=white)
![.NET](https://img.shields.io/badge/.NET-Integration-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-Caching-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Git](https://img.shields.io/badge/Git-Version%20Control-F05032?style=for-the-badge&logo=git&logoColor=white)

</p>

---

## 🧭 Descripción

**NUTRIA** es un laboratorio práctico orientado al desarrollo de un sistema de gestión de pensiones utilizando **Oracle Database y PL/SQL**.

El laboratorio parte de requerimientos funcionales y evoluciona progresivamente desde el diseño de la base de datos hasta escenarios relacionados con:

- 🧩 Arquitectura
- ⚙️ PL/SQL
- 🔐 Concurrencia
- ⚡ Performance
- 🛠️ Optimización
- 🔄 Deuda técnica
- ☕ Java / .NET
- 🚀 Caching con Redis
- 📊 Observabilidad
- 🔁 CI/CD
- 🤖 IA / MCP

> 📌 **Nota:** Este proyecto es un laboratorio educativo y no representa la arquitectura interna ni las reglas reales de ninguna entidad pensional.

---

# 🎯 Objetivos

El laboratorio busca desarrollar la capacidad de:

| Área | Objetivo |
|---|---|
| 🗄️ Oracle | Diseñar y trabajar con bases de datos Oracle |
| 💻 PL/SQL | Implementar lógica de negocio |
| 📦 Packages | Organizar la lógica por dominios |
| 🚨 Exceptions | Gestionar errores técnicos y de negocio |
| 🔄 Transactions | Comprender transacciones y consistencia |
| 🔐 Concurrency | Trabajar con múltiples procesos simultáneos |
| ⚡ Performance | Detectar y analizar problemas de rendimiento |
| 🛠️ Optimization | Resolver escenarios de deuda técnica |
| 📦 Batch | Procesar grandes volúmenes de información |
| ☕ Java / .NET | Integrar Oracle con aplicaciones |
| 🚀 Redis | Implementar estrategias de caching |
| 📊 Observability | Identificar cuellos de botella |
| 🔁 CI/CD | Versionar y automatizar cambios |
| 🤖 IA / MCP | Explorar integración de agentes con el sistema |

---

# 🏗️ Evolución del laboratorio

El proyecto seguirá progresivamente este flujo:

```text
                         📝 REQUERIMIENTOS
                                │
                                ▼
                         🗄️ TABLAS
                                │
                                ▼
                       🔒 CONSTRAINTS
                                │
                                ▼
                    📦 PACKAGE SPECIFICATIONS
                                │
                                ▼
                       📦 PACKAGE BODIES
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
         Procedures         Functions          Cursors
              │                 │                 │
              └─────────────────┼─────────────────┘
                                ▼
                         🚨 EXCEPTIONS
                                │
                                ▼
                       🔄 TRANSACTIONS
                                │
                                ▼
                         ⚡ TRIGGERS
                                │
                                ▼
                       🧪 PRUEBAS
                                │
                                ▼
                       🔐 CONCURRENCIA
                                │
                                ▼
                    📊 PERFORMANCE ORACLE
                                │
                                ▼
                     🛠️ OPTIMIZACIÓN
                                │
                                ▼
                       🧱 DYNAMIC SQL
                                │
                                ▼
                       ⏰ BATCH / JOBS
                                │
                                ▼
                       📝 AUDITORÍA
                                │
                                ▼
                       ☕ JAVA / .NET
                                │
                                ▼
                       🚀 REDIS / CACHE
                                │
                                ▼
                      📈 OBSERVABILIDAD
                                │
                                ▼
                          🔁 CI/CD
                                │
                                ▼
                           🤖 IA / MCP
```

---

# 🏦 Dominios funcionales

## 👤 PKG_AFILIADOS

Gestión de afiliados:

- Crear afiliado
- Consultar afiliado
- Consultar afiliados
- Actualizar afiliado
- Activar afiliado
- Deshabilitar afiliado
- Calcular edad

### Reglas principales

- Campos obligatorios
- Documento único
- Existencia del afiliado
- Estado válido
- Fecha de nacimiento válida

---

## 💰 PKG_APORTES

Gestión de aportes:

- Registrar aportes
- Consultar aportes
- Actualizar aportes
- Cambiar estado
- Calcular total aportado
- Contar aportes

### Reglas principales

- Unicidad por afiliado, empresa y período
- Valores positivos
- Estados válidos
- Control de aportes cerrados
- Control de transiciones de estado

---

## 💼 PKG_HISTORIAL_LABORAL

Gestión del historial laboral:

- Registrar historial
- Actualizar historial
- Eliminar historial
- Consultar historial
- Calcular tiempo laborado

### Información gestionada

```text
Empresa
Cargo
Salario
Fecha de inicio
Fecha de finalización
```

---

## 🧓 PKG_PENSIONES

Gestión de solicitudes de pensión:

- Crear solicitud
- Actualizar estado
- Aprobar solicitud
- Rechazar solicitud
- Consultar solicitud
- Consultar solicitudes por afiliado
- Validar requisitos
- Calcular semanas cotizadas

La validación podrá considerar:

```text
👤 Afiliado
      +
📅 Edad
      +
💼 Historial laboral
      +
💰 Aportes
      +
🏛️ Régimen
      +
📋 Tipo de pensión
      +
⚙️ Parámetros configurables
```

---

## 🏢 PKG_EMPRESAS

Gestión de empresas aportantes:

- Registrar empresa
- Consultar empresa
- Actualizar empresa
- Activar empresa
- Deshabilitar empresa
- Consultar deuda
- Registrar pagos

También se estudiará el comportamiento de operaciones sobre deuda bajo concurrencia.

---

## 🚨 PKG_ERRORES

Componente transversal para:

- Gestionar códigos de error
- Gestionar mensajes
- Registrar errores
- Consultar errores
- Estandarizar errores
- Centralizar `RAISE_APPLICATION_ERROR`

---

# 🗄️ Modelo de datos

```text
                         👤 AFILIADO
                              │
                ┌─────────────┼─────────────┐
                │             │             │
                ▼             ▼             ▼
             💰 APORTES   💼 HISTORIAL   🧓 SOLICITUD
                │             │             │
                │             │             ▼
                │             │          🏦 PENSION
                │             │
                └──────┬──────┘
                       ▼
                    🏢 EMPRESA


        ⚙️ PARAMETRO_PENSION
        📝 AUDITORIA
        🚨 ERROR_SISTEMA
```

---

# 📦 Packages

La lógica de negocio se organizará por dominio:

```text
Oracle Database
│
├── 👤 PKG_AFILIADOS
│
├── 💰 PKG_APORTES
│
├── 💼 PKG_HISTORIAL_LABORAL
│
├── 🧓 PKG_PENSIONES
│
├── 🏢 PKG_EMPRESAS
│
└── 🚨 PKG_ERRORES
```

Cada package podrá contener:

```text
├── Procedures
├── Functions
├── Cursors
├── Exceptions
└── Tipos / variables
```

---

# 🔐 Concurrencia

Se estudiará el comportamiento de Oracle cuando múltiples procesos trabajan simultáneamente sobre los mismos datos.

### Temas

```text
🔒 SELECT FOR UPDATE
⏱️ NOWAIT
⏭️ SKIP LOCKED
🔐 Locks
⚠️ Condiciones de carrera
💥 Deadlocks
```

### Objetivo

Comprender cómo mantener la consistencia de los datos cuando existen múltiples operaciones concurrentes.

---

# ⚡ Performance Oracle

Esta será una de las etapas principales del laboratorio.

### Temas

```text
📌 Índices
📊 EXPLAIN PLAN
🔎 DBMS_XPLAN
🐌 Consultas lentas
🔁 SQL dentro de loops
📦 BULK COLLECT
⚡ FORALL
⏱️ Medición / Profiling
```

La metodología será:

```text
       📏 MEDIR
          │
          ▼
     🔎 ANALIZAR
          │
          ▼
   🎯 IDENTIFICAR
          │
          ▼
      🛠️ CAMBIAR
          │
          ▼
       🧪 PROBAR
          │
          ▼
       📏 MEDIR
          │
          ▼
     📊 COMPARAR
```

---

# 🛠️ Optimización y deuda técnica

Se crearán escenarios deliberadamente mejorables para practicar:

- Refactorización
- Eliminación de operaciones innecesarias
- Optimización de consultas
- Reducción de procesamiento fila por fila
- Procesamiento masivo
- Comparación antes/después

### Ejemplo

```text
🔴 ANTES

Consulta:       2800 ms
Plan:           Full Table Scan


             ↓ OPTIMIZACIÓN ↓


🟢 DESPUÉS

Consulta:        200 ms
Plan:            Index Range Scan
```

El objetivo será aprender a **demostrar una mejora mediante medición**, no asumir que una modificación es mejor simplemente porque parece más eficiente.

---

# 🧱 Dynamic SQL

Se estudiarán:

```text
⚙️ EXECUTE IMMEDIATE
🔎 DBMS_SQL
```

El objetivo será comprender cómo funciona SQL dinámico y poder reconocer y mantener código legacy que utilice estas herramientas.

---

# ⏰ Batch / Jobs

Se implementarán procesos programados mediante:

```text
DBMS_SCHEDULER
```

Ejemplo:

```text
🌙 02:00 AM
      │
      ▼
   ⏰ JOB
      │
      ▼
📦 PKG_APORTES
      │
      ▼
Procesamiento masivo
```

---

# 📝 Auditoría / Logs

Se implementará una estructura de auditoría para registrar cambios realizados sobre los datos.

Información contemplada:

```text
📋 Tabla afectada
🔧 Operación
🆔 Registro afectado
👤 Usuario
📅 Fecha
⬅️ Valor anterior
➡️ Valor nuevo
```

---

# ☕ Java / .NET

Posteriormente se incorporará una capa de aplicación.

```text
                    🌐 FRONTEND
                         │
                         ▼
                 ☕ JAVA / .NET
                         │
                         ▼
                    Controller
                         │
                         ▼
                      Service
                         │
                         ▼
                  Repository / DAO
                         │
                         ▼
                   JDBC / ODP.NET
                         │
                         ▼
                  📦 ORACLE PACKAGE
                         │
                         ▼
                      PL/SQL
                         │
                         ▼
                  🗄️ ORACLE DATABASE
```

Se estudiará especialmente el consumo de:

- Procedures
- Functions
- `SYS_REFCURSOR`
- Transacciones
- Excepciones

---

# 🚀 Alto volumen y Redis

Se estudiarán escenarios donde una aplicación recibe un volumen elevado de llamadas.

Conceptos:

```text
🔌 Connection Pool
🚀 Redis
🧠 Cache-aside
⏳ TTL
♻️ Invalidación
```

Flujo conceptual:

```text
                     API
                      │
                      ▼
                   Redis
                 ╱       ╲
              HIT         MISS
               │             │
               ▼             ▼
           ⚡ Respuesta     Oracle
                             │
                             ▼
                           Redis
                             │
                             ▼
                          Respuesta
```

El objetivo será comprender cuándo utilizar caching y cuándo el problema debe resolverse directamente en Oracle.

---

# 📊 Observabilidad

Se estudiará cómo localizar un cuello de botella dentro de una aplicación.

Ejemplo:

```text
Request total       3000 ms
│
├── Controller         5 ms
├── Service           10 ms
├── Repository        20 ms
└── Oracle          2965 ms  🔴
```

Se analizarán:

```text
📋 Logs
📈 Métricas
🔎 Trazas
⏱️ Tiempos de respuesta
🔬 Profiling
```

El objetivo será identificar si el problema se encuentra en:

```text
Frontend
API
Java / .NET
Repository
JDBC / ODP.NET
Oracle
SQL
Infraestructura
```

---

# 🔄 CI/CD

El proyecto incorporará progresivamente un flujo de desarrollo versionado:

```text
💻 Código
   │
   ▼
🌿 Git
   │
   ▼
🧪 Tests
   │
   ▼
🏗️ Build
   │
   ▼
🔧 Jenkins
   │
   ▼
🚀 Deploy
```

---

# 🤖 IA / MCP

Como etapa experimental se explorará la integración de agentes de IA con el proyecto.

Arquitectura conceptual:

```text
                  🤖 AGENTE IA
                       │
                       ▼
                     MCP
                       │
                       ▼
                 MCP SERVER
                       │
                       ▼
              HERRAMIENTAS AUTORIZADAS
                       │
                ┌──────┴──────┐
                ▼             ▼
             Oracle          APIs
                │
                ▼
             Packages
                │
                ▼
             PL/SQL
```

Ejemplo conceptual:

```text
"Crea un afiliado llamado Carlos Pérez"
                    │
                    ▼
                🤖 Agente
                    │
                    ▼
                 MCP Tool
                    │
                    ▼
        PKG_AFILIADOS
        SP_ADD_AFILIADO
                    │
                    ▼
                 Oracle
```

---

# 📁 Estructura del repositorio

```text
NUTRIA/
│
├── 📄 README.md
│
├── 🗄️ database/
│   ├── tables/
│   ├── constraints/
│   ├── packages/
│   │   ├── specifications/
│   │   └── bodies/
│   ├── triggers/
│   ├── sequences/
│   ├── data/
│   ├── tests/
│   └── performance/
│
├── ☕ java/
│
├── 💜 dotnet/
│
├── ⏰ batch/
│
├── 🚀 redis/
│
├── 📚 docs/
│
└── 🚫 .gitignore
```

---

# 🧠 Enfoque del laboratorio

El laboratorio no busca únicamente crear funcionalidades.

Una parte importante estará enfocada en **comprender, diagnosticar y resolver deuda técnica**.

La metodología será:

```text
        🧠 ENTENDER
             ↓
        📏 MEDIR
             ↓
        🔎 ANALIZAR
             ↓
     🎯 IDENTIFICAR PROBLEMA
             ↓
       💡 PROPONER CAMBIO
             ↓
        🛠️ IMPLEMENTAR
             ↓
          🧪 PROBAR
             ↓
        📏 MEDIR DE NUEVO
             ↓
        📊 COMPARAR
```

Ante una operación con problemas de rendimiento se analizará:

```text
❓ ¿Qué hace?
❓ ¿Quién la llama?
❓ ¿Qué tablas utiliza?
❓ ¿Qué SQL ejecuta?
❓ ¿Cuántas veces se ejecuta?
❓ ¿Utiliza índices?
❓ ¿Qué plan de ejecución tiene?
❓ ¿Existe concurrencia?
❓ ¿Hay SQL dentro de loops?
❓ ¿Existen operaciones innecesarias?
❓ ¿Puede utilizar procesamiento masivo?
❓ ¿Tiene sentido utilizar cache?
```

---

# 🏁 Resultado esperado

Al finalizar el laboratorio se busca contar con una visión **end-to-end** del desarrollo y mantenimiento de un sistema empresarial basado en Oracle:

```text
📝 Requerimiento
       ↓
📐 Regla de negocio
       ↓
🗄️ Modelo de datos
       ↓
🔒 Constraints
       ↓
📦 Packages
       ↓
⚙️ PL/SQL
       ↓
🚨 Exceptions
       ↓
🔄 Transactions
       ↓
⚡ Triggers
       ↓
🧪 Pruebas
       ↓
🔐 Concurrencia
       ↓
📊 Performance
       ↓
🛠️ Optimización
       ↓
☕ Java / .NET
       ↓
🚀 Redis
       ↓
📈 Observabilidad
       ↓
🔄 CI/CD
       ↓
🤖 IA / MCP
```

## 🎓 Objetivo final

Desarrollar la capacidad de **entender, mantener, diagnosticar y optimizar componentes Oracle/PLSQL**, especialmente en escenarios donde existen:

- Alto volumen de llamadas.
- Código legacy.
- Deuda técnica.
- Problemas de rendimiento.
- Procesamiento masivo.
- Concurrencia.
- Necesidad de caching.
- Integración con APIs.
- Procesos Batch.
- Observabilidad.
- Automatización.
- Integración con agentes de IA.

---

## 📚 Documentación

Los requerimientos funcionales utilizados como base del laboratorio se encuentran en:

```text
docs/
└── NUTRIA_Requerimientos.docx
```

El desarrollo del laboratorio seguirá estos requerimientos como punto de partida y posteriormente incorporará las fases técnicas de performance, arquitectura, integración y automatización.
