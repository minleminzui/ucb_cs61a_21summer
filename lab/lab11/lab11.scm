(define-macro (def func args body)
              (list 'define func (list 'lambda args body)))
  ;`(define ,(cons func args) ,body))

(define (tail-replicate x n) 
  (define (tail-replicate-recursion x n lis)
    (if (= n 0) 
        lis 
        (tail-replicate-recursion x (- n 1) (cons x lis))))
  (tail-replicate-recursion x n nil))

(define (exp b n) 
  (define (exp-tail-recursion b n res)
    (if (= n 0) 
        res 
        (exp-tail-recursion b (- n 1) (* res b))))
  (exp-tail-recursion b n 1))
