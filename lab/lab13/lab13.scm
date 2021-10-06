(define (split-at lst n) 
    (define (inner lst s1 index)
            (if (or (zero? index) (null? lst))
                (cons s1 lst)
                (inner (cdr lst) (append s1 (list (car lst))) (- index 1))
            )
    )
    (inner lst nil n)
)

(define (compose-all funcs) 
    (define (inner x) 
            (if (null? funcs) 
                x
                ((compose-all (cdr funcs)) ((car funcs) x))
            )
    )
    inner
)
