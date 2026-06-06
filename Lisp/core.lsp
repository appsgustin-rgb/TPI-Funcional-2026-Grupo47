(defun transicion (color-actual color-siguiente)
    (cond
        ((and (equalp color-actual 'verde) (equalp color-siguiente 'amarillo)) (list color-actual color-siguiente))
        ((and (equlap color-actual 'amarillo) (equalp color-siguiente 'rojo)) (list color-actual color-siguiente))
        ((and (equalp color-actual 'rojo) (equalp color-siguiente 'verde)) (list color-actual color-siguiente))
        (t "transicion no valida")
        )
    )