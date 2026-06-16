Requerimiento 1: Estados de Transición
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

----------------------------------------------------------------------------------------------------------------------------------
Requerimiento 2: Temporizador Automático
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


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Requerimiento 3: Sistema de Auditoría
;; =========================================================
;; FUNCIÓN: auditoria 
;; NATURALEZA: Pura (no produce efectos secundarios en la pantalla ya que construye y retorna una cadena de texto)
;; ESTRATEGIA: Función condicional (utiliza un cond para evaluar el color de destino mediante comparaciones con equalp)
;; IMPACTO: No destructiva (no altera ni modifica los símbolos o valores recibidos por los argumentos)
;; ===========================================================
(defun auditoria (colorActual timestampActual)      ;requerimiento 3
    (cond
        ((equalp colorActual 'rojo) (format nil "~Tiempo ~a: la luz ha cambiado de amarillo a rojo" timestampActual))
        ((equalp colorActual 'verde) (format nil "~Tiempo ~a: la luz ha cambiado de rojo a verde" timestampActual))
        (t (format nil "~Tiempo ~a: la luz a cambiado de verde a amarillo" timestampActual))))

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Requerimiento 4a: Funcion Duracion-Ciclo
;; ========================================================
;; FUNCIÓN: duracionCiclo
;; NATURALEZA: Pura (recibe valores numeros, realiza un calculo aritmetico y devuelve el resultado)
;; ESTRATEGIA: Funcion condicional (Segun sea el tipo de dato recibido, se valida y realiza una operacion aritmetica)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ======================================================== 
(defun duracionCiclo (segVerde segAmarillo segRojo) ;requerimiento 4.a
    (cond
        ((and (numberp segVerde) (numberp segAmarillo) (numberp segRojo)) (+ segVerde segAmarillo segRojo))
        (t nil)))
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Requerimiento 4b: Funcion Recomendacion-Ciclo
;; ========================================================
;; FUNCIÓN: recomendacionCiclo
;; NATURALEZA: Pura (recibe un valor de duracion de ciclo y retorna una cadena de texto evaluando las condiciones)
;; ESTRATEGIA: Funcion condicional (Evalua el rango numérico del ciclo para sugerir optimizaciones)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ========================================================
(defun recomendacionCiclo (ciclo) ;requerimiento 4.b
    (cond 
        ((null ciclo) "Error: El parámetro debe ser un número")
         ((and (<= ciclo 150) (>= ciclo 35)) "Duracion OPTIMA")
         ((< ciclo 35) "Duracion NO OPTIMA aumentar duracion del ciclo")
         (t "Duracion NO OPTIMA reducir duracion del ciclo")))
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Requerimiento 5: Planificacion Temporal
;; ========================================================
;; FUNCIÓN: ciclosPorTiempo
;; NATURALEZA: Pura (recibe un valor de tiempo en minutos y calcula la cantidad de ciclos enteros)
;; ESTRATEGIA: Funcion aritmetica (Aplica division y truncamiento para retornar una cadena con format)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ========================================================
(defun ciclosPorTiempo (minutos)       ;requerimient0 5
    (cond 
        ((and (numberp minutos) (> minutos 0)) (format nil "Cantidad de ciclos completos en ~a minutos: ~a" minutos (truncate (/ (* minutos 60) 216))))
        (t "Error: El parámetro debe ser un número positivo")))
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Requerimiento 6: Informe de Distribucion Temporal
;; ========================================================
;; FUNCIÓN: distribucionTemp
;; NATURALEZA: Pura (realiza calculos porcentuales de distribucion de tiempo fijos y devuelve el formato)
;; ESTRATEGIA: Funcion aritmetica (Calcula relaciones matematicas basadas en tiempos predeterminados)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ========================================================
(defun distribucionTemp ()     ;requerimiento 6
    (format nil "verde: %~a, amarillo: %~a, rojo: %~a." (* (/ (* 120 16.6) 3600) 100) (* (/ (* 6 16.6) 3600) 100) (* (/ (* 90 16.6) 3600) 100)))
