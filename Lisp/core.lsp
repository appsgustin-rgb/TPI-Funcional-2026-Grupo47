Requerimiento 1: Estados de Transición
;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura (devuele el mismo resultado para los mismos argumentos de entrada)
;; ESTRATEGIA: Funcion condicional (va a evaluar los valores de entrada según las condiciones establecidas)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ========================================================
(defun transicion (color-actual cambiar-a)
	(cond (	(eq cambiar-a 'verde)    (list color-actual "cambiar-a-verde"))
	      ( (eq cambiar-a 'rojo)     (list color-actual "cambiar-a-rojo"))
	      ( (eq cambiar-a 'amarillo) (list color-actual "cambiar-a-amarillo"))
	      (t (list color-actual 'accion-por-defecto))))
----------------------------------------------------------------------------------------------------------------------------------
Requerimiento 2: Temporizador Automático
;; ========================================================
;; FUNCIÓN: posEnCiclo ;; Auxiliar
;; NATURALEZA: Pura (recibe valores numeros y devuelve el mismo tipo)
;; ESTRATEGIA: Posicion del timer dentro del intervalo de ciclo
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ========================================================
(defun posEnCiclo (primerTimestamp timestampActual)                  
      (IF (AND (numberp primerTimestamp) (numberp timestampActual))
		(mod (- timestampActual primerTimestamp) 216)
		nil))

;; ========================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura (recibe valores numeros y devuelve el mismo tipo)
;; ESTRATEGIA: Funcion condicional (Segun sea la posicion en el ciclo, se determina el color actual de la luz)
;; IMPACTO: No destructiva (no modifica las variables originales)
;; ========================================================
(defun timer (primerTimestamp timestampActual)
  (let ((pos (posEnCiclo primerTimestamp timestampActual)))
    (cond ((< pos 90)  'rojo)      ; De 0 a 89 (90 segundos)
          ((< pos 96)  'amarillo)  ; De 90 a 95 (6 segundos)
          (t           'verde))))  ; De 96 a 215 (120 segundos)
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Requerimiento 3: Sistema de Auditoría
;; =========================================================
;; FUNCIÓN: auditoria 
;; NATURALEZA: Pura (no produce efectos secundarios en la pantalla ya que construye y retorna una cadena de texto)
;; ESTRATEGIA: Función condicional (utiliza un cond para evaluar el color de destino mediante comparaciones con equalp)
;; IMPACTO: No destructiva (no altera ni modifica los símbolos o valores recibidos por los argumentos)
;; ===========================================================
(defun auditoria (colorActual timestampActual)
    (cond
        ((equalp colorActual 'rojo) (format t "~Tiempo ~a: la luz a cambiado de amarillo a rojo" timestampActual))
        ((equalp colorActual 'verde) (format t "~Tiempo ~a: la luz a cambiado de rojo a verde" timestampActual))
        ((equalp colorActual 'amarillo) (format t "~Tiempo ~a: la luz a cambiado de verde a amarillo" timestampActual))
        (t nil)
        )
    )
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
(defun duracionCiclo (segVerde segAmarillo segRojo) ;requerimiento 4.a
    (cond
        (and (numberp segVerde) (numberp segAmarillo) (numberp segRojo)) (format t "Duración del ciclo: ~a segundos" (+ segVerde segAmarillo segRojo))
        (t "Error: Todos los parámetros deben ser números")
        )
    )

(defun recomendacionCiclo (ciclo) ;requerimiento 4.b
    (cond 
         ((and (< ciclo 150) (> ciclo 35)) "Duracion OPTIMA")
         ((ciclo < 35) "Duracion NO OPTIMA aumentar duracion del ciclo")
         (t "Duracion NO OPTIMA reducir duracion del ciclo")
        )
    )

(defun ciclosPorTiempo (ciclo minutos)       ;requerimient0 5
    (format t "Cantidad de ciclos en ~a minutos: ~a" minutos (truncate (/ (* minutos 60) ciclo)))
    )

(defun distribucionTemp () ;requerimiento 6
    (format t "verde: %~v, amarillo: %~a, rojo: %~r." (* (/ 120 3600) 100) (* (/ 6 3600) 100) (* (/ 90 3600) 100))
    )
