<div align="center">
  <img src="https://exa.unne.edu.ar/rfa/images/facena_logo_azul.png" alt="Logo FaCENA" width="300"/><br/>
  <h2>Facultad de Ciencias Exactas y Naturales y Agrimensura</h2>
  <h3>Universidad Nacional del Nordeste</h3>
  <hr size="2px" color="black"/>
  <h1>Trabajo Práctico Integrador: Núcleo Lógico de Tráfico Inteligente</h1>
  <strong>Asignatura:</strong> Paradigmas de Programación (2026)<br/>
  <strong>Tecnología Principal:</strong> Common Lisp (SBCL) & Scheme<br/>
</div>

---

## 1. Identificación del Equipo

* **Estudiante 1:** [Romero, Agustin Ezequiel] - Correo: [agustinezequielromero15@gmail.com]
* **Estudiante 2:** [Retamoso, Lisandro Agustin] - Correo: [retamosolisandroagustin000@gmail.com]
* **Estudiante 3:** [Salguero, Benjamin] - Correo: []
* **Estudiante 4:** [Roa, Alan Gabriel] - Correo: []
* **Estudiante 5:** [Sotelo, Javier David] - Correo: []

* **Ecosistema Analizado:** Integración de Quicklisp, manejo temporal avanzado con `local-time` e implementación comparativa multilingüe bajo el compilador SBCL.

---

## 2. Fundamentos del Diseño Funcional Adoptado

El núcleo del sistema se construyó casi en su totalidad con funciones puras. Las únicas excepciones son `auditoria` e `informe`, que por naturaleza tienen efectos secundarios de I/O: una escribe en disco y la otra produce salida en pantalla. Todo lo demás es puro: no modifica variables globales, no mantiene estado interno, y dada la misma entrada siempre devuelve la misma salida.

La razón de fondo no es estética. Estamos diseñando el módulo lógico de un sistema embebido que controla semáforos reales en intersecciones críticas de tráfico. En ese contexto, la predictibilidad matemática absoluta no es negociable: si una función puede comportarse diferente según el estado del sistema en el momento de la llamada, rastrear un fallo en producción se vuelve casi inmanejable. Con funciones puras, el testing es directo, los resultados son reproducibles en cualquier entorno y la corrección se puede verificar de forma aislada para cada función.

Para la máquina de estados de `transicion` y `timer` usamos `cond`. Meter `if` anidados hubiera vuelto el código ilegible bastante rápido: con más de tres fases, la indentación crece y se arruina la legibilidad. El `cond` mapea de forma directa cada fase del semáforo, con una cláusula por condición, y el flujo queda explícito de un vistazo. Este enfoque además respeta los criterios y directivas dictados por los profesores en las clases prácticas y de laboratorio.

La matemática del Requerimiento 2 requiere una explicación aparte. El ciclo completo dura **225 segundos**, valor que surge de la Extensión 1: agregamos 3 segundos de intermitencias de seguridad a cada color (Rojo: 90+3, Amarillo: 6+3, Verde: 120+3). El desafío era tomar un timestamp Unix arbitrario —del tipo `1171810800`, un número enorme— y proyectarlo sobre ese rango. Acá usamos `(mod timestamp 225)`, que colapsa cualquier entero en el intervalo indexado 0-224 de forma limpia. No importa cuántos segundos hayan pasado desde el Epoch: el resultado siempre cae dentro del ciclo. Esta propiedad es lo que permite calcular el estado del semáforo en cualquier punto temporal sin almacenar estado mutable entre llamadas.

---

## 3. Justificación e Integración de Librerías (Fase 2)

El requerimiento de auditoría forense planteaba un problema operativo concreto: un log lleno de enteros Unix crudos como `1171810800` es completamente ilegible para un operador humano. Para saber a qué instante corresponde ese valor hay que convertirlo a mano, lo que hace que los registros pierdan todo su valor en el momento en que más importan.

Para resolverlo integramos `local-time` vía Quicklisp. La carga se hace con `(ql:quickload "local-time" :silent t)`, de forma silenciosa para no contaminar la salida del sistema con mensajes de descarga o compilación. Lo importante es cómo aislamos esa dependencia: no llamamos a las funciones de `local-time` directamente desde la lógica de auditoría. Construimos una capa de abstracción con dos funciones intermedias: `unix-a-timestamp` convierte el entero Unix a un objeto timestamp interno de la librería, y `timestamp-a-string` lo formatea como cadena legible para el log. Si en algún momento hubiera que cambiar o actualizar la librería de manejo temporal, solo se tocan esas dos funciones; el resto del sistema queda intacto.

Un detalle que tuvimos en cuenta y que puede parecer menor: forzamos la zona horaria a UTC con la constante `local-time:+utc-zone+` en todas las conversiones. Esto garantiza que dos instancias del sistema corriendo en máquinas con configuraciones regionales distintas —por ejemplo, una en UTC-3 y otra en UTC+0— produzcan registros idénticos para el mismo instante. La homogeneidad de los logs es condición necesaria para cualquier análisis forense serio.

---

## 4. Bitácora de Depuración y Resolución de Bugs

### Bug 1 — Corrupción en el buffer de desarrollo al iniciar

Al levantar el entorno interactivo para trabajar con SBCL, el buffer de interacción se congelaba antes de terminar de cargar. El mensaje era `End of file during parsing` y el REPL nunca llegaba a estar disponible. El problema era que el entorno intenta restaurar el historial de la sesión anterior, y si ese archivo quedó truncado —por un cierre abrupto, por ejemplo— el parser se cae en la primera lectura inconsistente.

La solución fue enviar la confirmation de ignorar el historial corrupto directamente desde los comandos del editor, lo que le indica al entorno que descarte ese registro y levante SLIME desde cero. Renegamos un rato hasta entender que el problema no estaba en nuestro código sino en el estado persistido del entorno de la sesión anterior.

### Bug 2 — Conflicto de directiva de formato `~T`

Al escribir la función de auditoría, pegamos la tilde directamente a la palabra en la cadena de formato, dejándolo como `"~Tiempo"`. SBCL lo rechazaba con un error de compilación porque `~T` es la directiva nativa de tabulación en Common Lisp. El compilador no tiene forma de distinguir si la intención era tabular o imprimir la cadena literal "Tiempo".

Corregimos espaciando la expresión: `"Tiempo ~a"`. El fix fue de un carácter, pero el mensaje de error de SBCL no apunta directamente a la cadena de formato, así que nos costó un rato ubicar exactamente dónde estaba el problema.

### Bug 3 — Desfase de base en la función `timer`

Al implementar la lógica temporal, el mapeo inicial indexaba el ciclo arrancando en 1. Eso generaba un segundo de desfasaje que rompía los límites de todas las cláusulas del `cond`: el sistema asignaba el estado equivocado exactamente en las fronteras entre fases, donde el comportamiento correcto es más crítico.

La corrección fue realinear el reloj a base 0 para sincronizarlo con el comportamiento natural de `mod`, que devuelve valores en el rango `[0, n-1]`. Después de ese ajuste los límites del `cond` quedaron alineados con las fases reales del ciclo.

### Bug 4 — Excepción de tipo en los predicados aritméticos del `cond`

Durante las pruebas sobre flujos alternativos, descubrimos que si la función recibía un argumento inválido (como un string en lugar de un entero), la función que calculaba la posición en el ciclo devolvía un mensaje de error en formato cadena. Al no haber ninguna barrera de entrada, ese string se inyectaba directo en predicados aritméticos como `(< pos 90)`, haciendo colapsar a SBCL en tiempo de ejecución con un error de tipo.

Insertamos `(if (not (numberp ...)) ...)` al inicio de la función, antes de cualquier operación matemática. Funciona como portero lógico: si la entrada no es un número, la función corta ahí y devuelve un valor de error controlado sin llegar nunca a los comparadores.

### Bug 5 — Fracciones exactas en la salida del reporte de distribución porcentual

En el Requerimiento 6, las primeras versiones de la fórmula de porcentaje mostraban en la terminal valores como `40/3` en lugar de decimales. El origen estaba en la aritmética racional por defecto de Common Lisp: cuando todos los operandos son enteros, el operador `/` devuelve fracciones exactas en lugar de números de punto flotante. Al pasar esos valores a `format`, la salida era una fracción irreducible, no un porcentaje legible.

Reestructuramos la lógica usando una función lambda interna `pct` con base de ciclo fija en 225s y aplicamos `float` explícitamente sobre el numerador antes de la división. Esto fuerza la aritmética de punto flotante en toda la cadena de cálculo. Con ese cambio los porcentajes cerraron correctamente y la salida del reporte quedó en el formato que pedían los requerimientos.

---

## 5. Análisis Comparativo Paradigmático (Fase 3)

### Comparadores de igualdad

En Common Lisp usamos `equalp` para comparar los símbolos de estado del semáforo. La ventaja de `equalp` es que es insensible a mayúsculas/minúsculas y cubre la comparación de distintos tipos sin necesidad de conversiones explíticas, lo que en las pruebas nos permitía escribir los casos de forma natural sin preocuparnos por la capitalización de los símbolos. En Scheme, en cambio, usamos `equal?`: el predicado estándar de equivalencia estructural recursiva, que compara el contenido en profundidad. Las semánticas son similares en el caso que nos ocupaba, pero la diferencia de nomenclatura y de alcance de cada predicado refleja decisiones de diseño distintas en cada dialecto.

### Espacios de Nombres

Common Lisp es un **Lisp-2**: mantiene espacios de nombres separados para funciones y variables. Podemos tener una función llamada `pct` y una variable llamada `pct` en el mismo ámbito sin que se pisen, porque el intérprete sabe cuándo buscar en cada espacio según el contexto sintáctico. La contracara es que al invocar una lambda guardada en una variable —como nuestra función `pct`— hay que hacerlo explícitamente con `funcall` o `apply`; llamarla directamente como si fuera una función nombrada no funciona.

Scheme es un **Lisp-1**: hay un único espacio de nombres para todo. Las funciones se definen con `define` y se tratan directamente como valores de primera clase, igual que cualquier otro objeto. Al invocar una función guardada en una variable no hace falta ningún operador especial; la llamada es directa y el código resulta más uniforme en ese sentido.

### Recursividad y TCO en la Extensión 2

Para el volcado de logs en archivo implementamos en Lisp la función auxiliar `escribir-entradas` con recursividad de cola, combinada con `with-open-file` para el manejo del stream. La clave es la **Tail-Call Optimization (TCO)**: cuando la llamada recursiva es la última operación en ejecutarse dentro de la función, el compilador la transforma en un salto iterativo a bajo nivel. El frame de la llamada anterior se reutiliza en lugar de apilar uno nuevo, lo que elimina el crecimiento de la pila.

En Scheme el TCO es mandatorio por la especificación R7RS: cualquier implementación que no lo garantice no es un Scheme conforme al estándar. En SBCL no está impuesto por el estándar de Common Lisp, pero el compilador lo detecta y aplica automáticamente cuando valida que la forma de cola es correcta. En ambos casos el efecto es el mismo: la función puede procesar cualquier volumen de entradas de log sin riesgo de stack overflow, sin importar la cantidad de registros de tráfico que haya que volcar al archivo.

---

## 6. Bibliografía y Fuentes Consultadas

- Graham, Paul. *ANSI Common Lisp*. Prentice Hall, 1995.
- Seibel, Peter. *Practical Common Lisp*. Apress, 2005. Disponible en línea: https://gigamonkeys.com/book/
- Quicklisp — Gestor de librerías para Common Lisp: https://www.quicklisp.org/
- Documentación de `local-time`: https://common-lisp.net/project/local-time/manual/
- Steel Bank Common Lisp (SBCL) — Manual de referencia: http://www.sbcl.org/manual/
- Sperber, Michael et al. *Revised⁷ Report on the Algorithmic Language Scheme (R7RS)*. 2013. Disponible en: https://small.r7rs.org/
- Felleisen, Matthias et al. *How to Design Programs*, 2ª ed. MIT Press. Disponible en línea: https://htdp.org/
