;; SISTEMA DE SEMÁFOROS INTELIGENTES
;; Fase 3 — Implementación Comparativa en Scheme


;; ============================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura (devuelve el mismo resultado para los
;;             mismos argumentos; sin efectos secundarios)
;; ESTRATEGIA: Función Condicional (evalúa los dos argumentos
;;             con cond + and; ninguna rama llama a transicion)
;; IMPACTO: No destructiva (no modifica los argumentos)
;; ============================================================
(define (transicion color-actual color-siguiente)
  (cond
    ;; Verde → paso intermedio
    ((and (equal? color-actual 'en-verde)
          (equal? color-siguiente 'amarillo))
     (list color-actual "cambiar-a-verde-intermitente"))

    ;; Verde-intermitente → Amarillo
    ((and (equal? color-actual 'en-verde-intermitente)
          (equal? color-siguiente 'amarillo))
     (list color-actual "cambiar-a-amarillo"))

    ;; Amarillo → paso intermedio
    ((and (equal? color-actual 'en-amarillo)
          (equal? color-siguiente 'rojo))
     (list color-actual "cambiar-a-amarillo-intermitente"))

    ;; Amarillo-intermitente → Rojo
    ((and (equal? color-actual 'en-amarillo-intermitente)
          (equal? color-siguiente 'rojo))
     (list color-actual "cambiar-a-rojo"))

    ;; Rojo → paso intermedio
    ((and (equal? color-actual 'en-rojo)
          (equal? color-siguiente 'verde))
     (list color-actual "cambiar-a-rojo-intermitente"))

    ;; Rojo-intermitente → Verde
    ((and (equal? color-actual 'en-rojo-intermitente)
          (equal? color-siguiente 'verde))
     (list color-actual "cambiar-a-verde"))

    ;; Transición no válida: devuelve símbolo accion-por-defecto
    (else
     (list color-actual 'accion-por-defecto))))


;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura (dado un timestamp, siempre retorna
;;             el mismo color; sin efectos secundarios)
;; ESTRATEGIA: Función Condicional (calcula la posición
;;             dentro del ciclo y la mapea al color activo)
;; IMPACTO: No destructiva (no modifica el argumento)
;; ============================================================
(define (timer timestamp-actual)
  (if (not (number? timestamp-actual))
      "error: solo numeros"
      (let ((pos (modulo (- timestamp-actual 1171810800) 225)))
        (cond
          ((< pos  90) 'rojo)
          ((< pos  93) 'rojo-intermitente)
          ((< pos  99) 'amarillo)
          ((< pos 102) 'amarillo-intermitente)
          ((< pos 222) 'verde)
          (else        'verde-intermitente)))))
