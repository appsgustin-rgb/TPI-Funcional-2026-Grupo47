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

(defun posEnCiclo (momentoInicio momentoActual)        ;funcion auxiliar para calcular la posicion en el ciclo de luces          
        (mod (- momentoActual momentoInicio) 216)      ;siempre da entre 1 y 216, que es la duracion total del ciclo de luces
    )
(defun timer (primerTimestamp timestampActual) ;requerimiento 2
    (cond
        ((< (posEnCiclo primerTimestamp timestampActual) 90) 'rojo)   ;segun sea la posicion en el ciclo, se determina el color actual de la luz
        ((< (posEnCiclo primerTimestamp timestampActual) 210) 'verde)
        (t 'amarillo)
        )
    )

(defun auditoria (colorActual timestampActual)      ;requerimiento 3
    (cond
        ((equalp colorActual 'rojo) (format t "~Tiempo ~a: la luz a cambiado de amarillo a rojo" timestampActual))
        ((equalp colorActual 'verde) (format t "~Tiempo ~a: la luz a cambiado de rojo a verde" timestampActual))
        ((equalp colorActual 'amarillo) (format t "~Tiempo ~a: la luz a cambiado de verde a amarillo" timestampActual))
        (t nil)
        )
    )

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
