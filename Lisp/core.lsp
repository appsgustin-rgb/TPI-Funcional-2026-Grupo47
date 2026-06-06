(defun transicion (color-actual color-siguiente)
    (cond
        ((and (equalp color-actual 'verde) (equalp color-siguiente 'amarillo)) (list color-actual "cambiar-a-amarillo"))
        ((and (equalp color-actual 'amarillo) (equalp color-siguiente 'rojo)) (list color-actual "cambiar-a-rojo"))
        ((and (equalp color-actual 'rojo) (equalp color-siguiente 'verde)) (list color-actual "cambiar-a-verde"))
        (t "transicion no valida")
        )
    )