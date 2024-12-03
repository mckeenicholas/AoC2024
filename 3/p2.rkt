#lang racket

(define get-input (with-input-from-file "input.txt" (lambda () (port->lines (current-input-port)))))

(define (extract-instructions input)
  (regexp-match* #rx"(don't\\(\\))|(do\\(\\))|(mul\\([0-9]+,[0-9]+\\))" input))

(define (do-mul item)
  (match (regexp-match* #rx"mul\\(([0-9]+),([0-9]+)\\)" item #:match-select rest)
    [(list (list x y))
     (let ([num-x (string->number x)]
           [num-y (string->number y)])
       (* num-x num-y))]))

(define (process-instructions input acc state)
  (match input
    [(cons "do()" rest) (process-instructions rest acc 't)]
    [(cons "don't()" rest) (process-instructions rest acc 'f)]
    [(cons mul rest)
     (let* ([mul-result (do-mul mul)]
            [new-acc (if (eq? state 't)
                         (+ acc mul-result)
                         acc)])
       (process-instructions rest new-acc state))]
    ['() acc]))

(define (process-mul-instructions lines)
  (let ([all-lines (string-join lines "\n")])
    (process-instructions (extract-instructions all-lines) 0 't)))

(displayln (process-mul-instructions get-input))
