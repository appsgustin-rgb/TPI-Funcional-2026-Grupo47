;; ============================================================
;; SISTEMA DE SEMÁFOROS INTELIGENTES - Common Lisp
;; Trabajo Práctico Integrador 2026
;; ============================================================

;; Carga de la librería local-time
 (load "ruta/de/quicklisp.lisp")
 (quicklisp-quickstart:install)
 (ql:add-to-init-file)
 (ql:quickload "local-time")
;; ------------------- FUNCIONES AUXILIARES -------------------
;; ============================================================
;; FUNCIÓN: unix-a-timestamp
;; NATURALEZA: Pura (misma entrada siempre produce la misma salida)
;; ESTRATEGIA: Función de Orden Superior (delegación a local-time:unix-to-timestamp)
;; IMPACTO: No destructiva
;; ============================================================
(defun unix-a-timestamp (unix-ts)
  (local-time:unix-to-timestamp unix-ts))

;; ============================================================
;; FUNCIÓN: timestamp-a-string
;; NATURALEZA: Pura (misma entrada siempre produce la misma salida)
;; ESTRATEGIA: Función de Orden Superior (delegación a local-time:format-timestring)
;; IMPACTO: No destructiva
;; ============================================================
(defun timestamp-a-string (unix-ts)
  (local-time:format-timestring
    nil
    (unix-a-timestamp unix-ts)
    :format '("[" (:year 4) "-" (:month 2) "-" (:day 2)
              " " (:hour 2) ":" (:min 2) ":" (:sec 2) "]")
    :timezone local-time:+utc-zone+))

;; ============================================================
;; FUNCIÓN: estado-a-texto
;; NATURALEZA: Pura (misma entrada siempre produce la misma salida)
;; ESTRATEGIA: Función Predicado / Condicional (evalúa símbolo y devuelve string legible)
;; IMPACTO: No destructiva
;; ============================================================
(defun estado-a-texto (estado)
  (cond
    ((equalp estado 'rojo)                  "ROJO")
    ((equalp estado 'rojo-intermitente)     "ROJO-INTERMITENTE")
    ((equalp estado 'amarillo)              "AMARILLO")
    ((equalp estado 'amarillo-intermitente) "AMARILLO-INTERMITENTE")
    ((equalp estado 'verde)                 "VERDE")
    ((equalp estado 'verde-intermitente)    "VERDE-INTERMITENTE")
    (t                                      "DESCONOCIDO")))

;; ----------------- FUNCIONES PRINCIPALES --------------------
;; ========================================================
;; REQUERIMIENTO 1: TRANCISION
;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura (devuele el mismo resultado para los mismos argumentos de entrada)
;; ESTRATEGIA: Funcion condicional (va a evaluar los valores de entrada según las condiciones establecidas)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ========================================================
(defun transicion (color-actual color-siguiente)
  (cond
    ((and (equalp color-actual 'en-verde)
          (equalp color-siguiente 'amarillo))
     (list color-actual "cambiar-a-verde-intermitente"))

    ((and (equalp color-actual 'en-verde-intermitente)
          (equalp color-siguiente 'amarillo))
     (list color-actual "cambiar-a-amarillo"))

    ((and (equalp color-actual 'en-amarillo)
          (equalp color-siguiente 'rojo))
     (list color-actual "cambiar-a-amarillo-intermitente"))

    ((and (equalp color-actual 'en-amarillo-intermitente)
          (equalp color-siguiente 'rojo))
     (list color-actual "cambiar-a-rojo"))

    ((and (equalp color-actual 'en-rojo)
          (equalp color-siguiente 'verde))
	(list color-actual "cambiar-a-rojo-intermitente"))

    ((and (equalp color-actual 'en-rojo-intermitente)
          (equalp color-siguiente 'verde))
     (list color-actual "cambiar-a-verde"))

    (t (list color-actual 'accion-por-defecto))))

;; ============================================================
;; ASEGURAMIENTO DE CALIDAD (Requerimiento 7)
;; ============================================================
;; -- Funcionamiento normal --
;; (transicion 'en-rojo 'verde)
;; => (EN-ROJO "cambiar-a-rojo-intermitente")

;; -- Camino alternativo --
;; (transicion 'en-verde 'rojo)
;; => (EN-VERDE ACCION-POR-DEFECTO)

;; -- Caso de error --
;; (transicion 'en-azul 'verde)
;; => (EN-AZUL ACCION-POR-DEFECTO)

;; ========================================================
;; REQUERIMIENTO 2: TIMER
;; ========================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura (recibe valores numeros y devuelve el mismo tipo)
;; ESTRATEGIA: Funcion condicional (Segun sea la posicion en el ciclo, se determina el color actual de la luz)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ========================================================
(defun timer (timestamp-actual)
  (if (not (numberp timestamp-actual))
      "error: solo numeros"
      (let ((pos (mod (- timestamp-actual 1171810800) 225)))
        (cond
          ((< pos  90) 'rojo)
          ((< pos  93) 'rojo-intermitente)
          ((< pos  99) 'amarillo)
          ((< pos 102) 'amarillo-intermitente)
          ((< pos 222) 'verde)
          (t           'verde-intermitente)))))

;; ============================================================
;; ASEGURAMIENTO DE CALIDAD (Requerimiento 7)
;; ============================================================

;; -- Funcionamiento normal --
;; (timer 1171810800)   
;; > ROJO
;; (timer 1171810845)   
;; > ROJO

;; -- Camino alternativo --
;; (timer 1171811025)   
;; > ROJO

;; -- Caso de error --
;; (timer "hoy")


;; ============================================================
;; REQUERIMIENTO 3: SISTEMA DE AUDITORÍA
;; ============================================================
;; FUNCIÓN: auditoria
;; NATURALEZA: Impura (imprime en terminal)
;; ESTRATEGIA: Función Condicional (usa format t para salida directa a terminal)
;; IMPACTO: No destructiva (no altera ni modifica los argumentos recibidos)
;; ============================================================ 
(defun auditoria (color-anterior color-nuevo timestamp-actual)
  (let ((fecha (timestamp-a-string timestamp-actual)))
    (format t "Tiempo ~a: la luz ha cambiado de ~a a ~a~%"
            fecha
            (estado-a-texto color-anterior)
            (estado-a-texto color-nuevo)))) 
;; ============================================================
;; REQUERIMIENTO 3 - ASEGURAMIENTO DE CALIDAD (Requerimiento 7)
;; ============================================================

;; -- Funcionamiento normal --
;; (auditoria 'rojo 'rojo-intermitente 1171810890)
;; > "Tiempo [2007-02-19 03:01:30]: la luz ha cambiado de ROJO a ROJO-INTERMITENTE"

;; -- Camino alternativo --
;; (auditoria (timer 1171810800) (timer 1171810890) 1171810890)
;; > "Tiempo [2007-02-19 03:01:30]: la luz ha cambiado de ROJO a ROJO-INTERMITENTE"

;; -- Caso de error --
;; (auditoria 'azul 'rojo 1171810800)
;; > "Tiempo [2007-02-19 03:00:00]: la luz ha cambiado de DESCONOCIDO a ROJO"

;; ============================================================
;; REQUERIMIENTO 4A: DURACIÓN DE CICLO
;; ============================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura (recibe valores numéricos, realiza cálculo aritmético y devuelve el resultado)
;; ESTRATEGIA: Función Condicional (valida los tipos de entrada antes de la operación aritmética)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ============================================================ 

(defun duracion-ciclo (seg-verde seg-amarillo seg-rojo seg-intermitencia)
  (cond
    ((and (numberp seg-verde) (numberp seg-amarillo)
          (numberp seg-rojo)  (numberp seg-intermitencia))
     (+ seg-verde seg-amarillo seg-rojo (* 3 seg-intermitencia)))
    (t nil)))

;; ============================================================
;; REQUERIMIENTO 4A - ASEGURAMIENTO DE CALIDAD (Requerimiento 7)
;; ============================================================

;; -- Funcionamiento normal --
;; (duracion-ciclo 120 6 90 3)
;;> 225
;; -- Camino alternativo --
;; (duracion-ciclo 60 6 90 3)    
;;> 165
;; -- Caso de error --
;; (duracion-ciclo 120 6 "noventa" 3) 
;;> NIL

;; ============================================================
;; REQUERIMIENTO 4B: RECOMENDACIÓN DE CICLO
;; ============================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura (recibe un valor de duración y retorna una cadena de texto sin efectos secundarios)
;; ESTRATEGIA: Función Predicado / Condicional (evalúa el rango numérico del ciclo)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ============================================================ 
(defun recomendacion-ciclo (ciclo)
  (cond
    ((null ciclo)    "Error: El parametro debe ser un numero")
    ((< ciclo 35)    "Duracion NO OPTIMA - aumentar duracion del ciclo")
    ((<= ciclo 150)  "Duracion OPTIMA")
    (t               "Duracion NO OPTIMA - reducir duracion del ciclo")))

;; ============================================================
;; REQUERIMIENTO 4B - ASEGURAMIENTO DE CALIDAD (Requerimiento 7)
;; ============================================================

;; -- Funcionamiento normal (rango óptimo: 35 a 150 segundos) --
;; (recomendacion-ciclo 35)     
;;> "Duracion OPTIMA"

;; -- Camino alternativo --
;; (recomendacion-ciclo 20)     
;;> "Duracion NO OPTIMA - aumentar duracion del ciclo"

;; -- Caso de error --
;; (recomendacion-ciclo nil)    
;;> "Error: El parametro debe ser un numero"

;; ============================================================
;; REQUERIMIENTO 5: PLANIFICACIÓN TEMPORAL
;; ============================================================
;; FUNCIÓN: ciclos-por-tiempo
;; NATURALEZA: Pura (recibe un valor en minutos y calcula la cantidad de ciclos enteros)
;; ESTRATEGIA: Función Aritmética (aplica división y truncamiento sobre el resultado de duracion-ciclo)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ============================================================ 

(defun ciclos-por-tiempo (minutos)
  (if (and (numberp minutos) (>= minutos 0))
      (let ((duracion (duracion-ciclo 120 6 90 3)))
        (format nil "Cantidad de ciclos completos en ~a minutos: ~a"
                minutos
                (truncate (/ (* minutos 60) duracion))))
      "Error: El parametro debe ser un numero positivo")) 
;; ============================================================
;; REQUERIMIENTO 5 - ASEGURAMIENTO DE CALIDAD (Requerimiento 7)
;; ============================================================

;; -- Funcionamiento normal --
;; (ciclos-por-tiempo 15)   
;;> "Cantidad de ciclos completos en 15 minutos: 4"

;; -- Camino alternativo --
;; (ciclos-por-tiempo 0)    => "Cantidad de ciclos completos en 0 minutos: 0"
;;
;; -- Caso de error --
;; (ciclos-por-tiempo -5)        
;;> "Error: El parametro debe ser un numero positivo"

;; ============================================================
;; REQUERIMIENTO 6: INFORME DE DISTRIBUCIÓN TEMPORAL
;; ============================================================
;; FUNCIÓN: distribucion-temp
;; NATURALEZA: Pura (realiza cálculos porcentuales y devuelve el formato sin efectos secundarios)
;; ESTRATEGIA: Función de Orden Superior (usa lambda como función auxiliar interna via funcall)
;; IMPACTO: No destructiva (no modifica variables originales)
;; ============================================================ 
(defun distribucion-temp ()
  (let* ((total (duracion-ciclo 120 6 90 3))
         (pct   (lambda (s) (float (* (/ s total) 100)))))
    (format nil
      "verde: ~,1f%, verde-intermitente: ~,1f%, amarillo: ~,1f%, amarillo-intermitente: ~,1f%, rojo: ~,1f%, rojo-intermitente: ~,1f%."
      (funcall pct 120) (funcall pct 3)
      (funcall pct 6)   (funcall pct 3)
      (funcall pct 90)  (funcall pct 3))))
;; ============================================================
;; REQUERIMIENTO 6 - ASEGURAMIENTO DE CALIDAD (Requerimiento 7)
;; ============================================================

;; -- Funcionamiento normal --
;; (distribucion-temp)
;; > "verde: 53.3%, verde-intermitente: 1.3%, amarillo: 2.7%, amarillo-intermitente: 1.3%, rojo: 40.0%, rojo-intermitente: 1.3%."

;; ============================================================
;; EXTENSIÓN 2: PERSISTENCIA DE DATOS
;; ============================================================
;; FUNCIÓN: escribir-entradas  (función auxiliar de informe)
;; NATURALEZA: Impura (escribe en archivo)
;; ESTRATEGIA: Recursiva de Cola (procesa la lista sin acumular pila)
;; IMPACTO: No destructiva (no modifica la lista de datos de entrada)
;; ============================================================ 

(defun escribir-entradas (stream datos)
  (when datos
    (let* ((entrada  (first datos))
           (fecha    (first  entrada))
           (estado   (second entrada))
           (mensaje  (third  entrada)))
      (format stream "~21a | ~20a | ~a~%"
              fecha
              (estado-a-texto estado)
              mensaje)
      (escribir-entradas stream (rest datos)))))
;; ============================================================
;; FUNCIÓN: informe
;; NATURALEZA: Impura (escribe en archivo)
;; ESTRATEGIA: Recursiva de Cola (delega la iteración a escribir-entradas)
;; IMPACTO: No destructiva (no modifica los datos de entrada)
;; ============================================================
(defun informe (datos)
  (with-open-file (stream "informe-ejecucion-semaforo.txt"
                          :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create)
    (format stream "Informe de Ejecucion del Sistema Semaforico~%")
    (format stream "==========================================~%")
    (format stream "~21a | ~20a | ~a~%" "FECHA/HORA" "ESTADO" "DESCRIPCION")
    (format stream "~a~%" "---------------------+----------------------+-------------------------------")
    (escribir-entradas stream datos)
    (format stream "~%--- Fin del Informe ---~%")))

;; ============================================================
;; EXTENSIÓN 2 - ASEGURAMIENTO DE CALIDAD (Requerimiento 7)
;; ============================================================

;; -- Funcionamiento normal --
;; (informe
;;   (list
;;     (list "[2007-02-19 03:00:00]" 'rojo               "Estado inicial del sistema")
;;     (list "[2007-02-19 03:01:30]" 'rojo-intermitente  "Entrando en intermitencia")
;;     (list "[2007-02-19 03:01:33]" 'amarillo            "Transicion a AMARILLO")
;;     (list "[2007-02-19 03:01:39]" 'amarillo-intermitente "Entrando en intermitencia")
;;     (list "[2007-02-19 03:01:42]" 'verde               "Transicion a VERDE")))
;; > crea "informe-ejecucion-semaforo.txt" con las entradas formateadas en tabla
;;
;; -- Camino alternativo  --
;; (informe (list))
;; > crea el archivo con encabezado y pie, sin entradas de datos
;;
;; -- Caso de error --
;; (informe (list (list "[2007-02-19 03:00:00]" 'azul "Estado inexistente")))
;; > escribe "DESCONOCIDO" en la columna ESTADO sin lanzar error
