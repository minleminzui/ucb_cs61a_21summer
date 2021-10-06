(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))

; Some utility functions that you may find useful to implement

(define (zip pairs)
  (define (inner lis s1 s2)
          (if (null? lis) (list s1 s2)
                          (inner (cdr lis) (append s1 (list (caar lis))) (append s2 (cdar lis)))
          )                
  )
  (inner pairs nil nil)
  )


;; Problem 16
;; Returns a list of two-element lists
(define (zip_ pairs)
  (define (ziped s ans) 
          (if (equal? s nil)
              ans
              (ziped (cddr s) (cons (cons (car s) (cons (cadr s) nil)) ans) )))
  (ziped pairs nil))
(define (enumerate s)
  ; BEGIN PROBLEM 15
  ; (define (inner lst ans index)
  ;         (if (equal? lst nil) 
  ;             ans 
  ;             (inner (cdr lst) 
  ;                     (cons ans (cons (cons index (cons (car lst) nil)) nil)) 
  ;                     (+ index 1))))
  ; (inner (cdr s) (cons 0 (cons (car s) nil)) 1))
  (define (paired pairs lst index)
          (if (equal? lst nil) 
              pairs
              (paired (cons index (cons (car lst) pairs))
                      (cdr lst)
                      (+ index 1))))
  (zip_ (paired nil s 0)))
  ; END PROBLEM 15

;; Problem 17
(define (reverse lst ans) 
        (if (equal? lst nil)
            ans
            (reverse (cdr lst) (cons (car lst) ans))))
;; Merge two lists LIST1 and LIST2 according to COMP and return
;; the merged lists.
(define (merge comp list1 list2)
  ; BEGIN PROBLEM 16
  (define (inner s1 s2 ans)
          (cond 
                ((and (equal? s1 nil) (equal? s2 nil)) ans)
                ((equal? s1 nil) (inner s1 (cdr s2) (cons (car s2) ans)))
                ((equal? s2 nil) (inner s2 (cdr s1) (cons (car s1) ans))) 
                ((comp (car s2) (car s1)) (inner s1 (cdr s2) (cons (car s2) ans)))
                (else (inner s2 (cdr s1) (cons (car s1) ans)))
                ))

  (reverse (inner list1 list2 nil) nil))
  ; END PROBLEM 16


;; Problem 18

;; Returns a function that checks if an expression is the special form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (let-to-lambda expr)
  (cond ((atom? expr)
         ; BEGIN PROBLEM 17
         expr
         ; END PROBLEM 17
         )
        ((quoted? expr)
         ; BEGIN PROBLEM 17
         expr
         ; END PROBLEM 17
         )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr))
               (body   (cddr expr)))
           ; BEGIN PROBLEM 17
           (cons form (cons params (map let-to-lambda body)))
           ; END PROBLEM 17
           ))
        ((let? expr)
         (let ((values (cadr expr))
               (body   (cddr expr)))
           ; BEGIN PROBLEM 17
           (define tmp (zip values))
           (append (cons (cons 'lambda (cons (car tmp) (map let-to-lambda body))) nil) (map let-to-lambda (cadr tmp)))
           ; END PROBLEM 17
           ))
        (else
         ; BEGIN PROBLEM 17
         (cons (car expr) (map let-to-lambda (cdr expr)))
         ; END PROBLEM 17
         )))

