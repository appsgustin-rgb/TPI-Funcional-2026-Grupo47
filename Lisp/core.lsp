(defun transicion (color-actual color-siguiente)         ;requerimiento 1
    (cond
        ((and (equalp color-actual 'verde) (equalp color-siguiente 'amarillo)) (list color-actual "cambiar-a-amarillo"))
        ((and (equalp color-actual 'amarillo) (equalp color-siguiente 'rojo)) (list color-actual "cambiar-a-rojo"))
        ((and (equalp color-actual 'rojo) (equalp color-siguiente 'verde)) (list color-actual "cambiar-a-verde"))
        (t nil)))

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