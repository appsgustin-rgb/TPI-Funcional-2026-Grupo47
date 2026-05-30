# TPI-Funcional-2026-Grupo[Numero]

> Sistema de Semáforos Inteligentes – Trabajo Práctico Integrador 2026

## 📌 Descripción

Implementación funcional en Common Lisp de un sistema de control de tráfico urbano con semáforos inteligentes. Incluye lógica de transiciones, temporización, auditoría, análisis de ciclos, planificación temporal, distribución porcentual y extensiones de seguridad y persistencia. Como parte del trabajo, se reimplementaron las funciones principales en [Lenguaje Asignado] para el análisis comparativo de paradigmas.

## 👥 Integrantes

| Nombre | Usuario GitHub |
|--------|----------------|
| Romero Agustin Ezequiel | appsgustin |
| Salguero Benjamin | usuario2 |
| Roa Gabriel Alan | usuario3 |
| Retamoso Lisandro | usuario4 |

## 📁 Estructura del repositorio
``` bash
TPI-Funcional-2026-Grupo47/
├── lisp/
│ ├── core.lisp # Código Requerimientos 1 a 6 + extensiones
│ └── config.json # Configuración de tiempos (si aplica)
├── comparativa/
│ └── solucion.scm # Código en SCHEME
├── docs/ 
│ ├── INFORME.pdf # Informe técnico analítico
│ └── HONOR.md # Declaración de código de honor
└── README.md
```
## ⚙️ Requisitos previos

- Common Lisp
- Quicklisp (para Fase 2)
- Scheme (Fase 3)

## ▶️ Ejecución

```bash
# Cargar el sistema
sbcl --load lisp/core.lisp

# Ejemplos de uso (dentro del REPL)
(transicion 'en-rojo 'verde)
(timer 1728000000)
```
## 🎥 Video de defensa
🚧En proceso🚧

## 📄 Documentación
Informe técnico completo: docs/INFORME.pdf

Declaración de honor: docs/HONOR.md

## 🧪 Lenguaje asignado (Fase 3)
Lenguaje: Scheme

Las funciones transicion y timer fueron reimplementadas en este lenguaje dentro de la carpeta /comparativa.

## ✅ Requerimientos cumplidos
R1 – Transición de estados

R2 – Temporizador automático (Unix timestamp)

R3 – Sistema de auditoría (logging en consola)

R4 – Duración y recomendación de ciclo

R5 – Ciclos por tiempo

R6 – Distribución porcentual por hora

Extensión 1 – Intermitencia de seguridad (3s)

Extensión 2 – Persistencia de loggin en archivo

Fase 2 – Quicklisp + [local-time / cl-json]

Fase 3 – Implementación en Scheme

## 🔍 Notas para el corrector
El código cumple con inmutabilidad absoluta (sin setq/setf/defparameter).

No se utilizan bucles imperativos (loop, dolist); se emplea recursividad de cola y funciones de orden superior.

Cada función incluye comentario de clasificación taxonómica (Naturaleza + Estrategia de control).

La bitácora de depuración con al menos 4 errores documentados está en docs/INFORME.pdf.

El historial de commits es incremental y cada integrante realizó contribuciones desde su propia cuenta.

## 📅 Fecha de entrega
Martes 16 de Junio

## Universidad Nacional del Nordeste / Paradigmas y lenguajes - 2026
