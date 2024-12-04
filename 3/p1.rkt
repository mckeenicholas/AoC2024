#lang racket

(define get-input (with-input-from-file "input.txt" (lambda () (port->lines (current-input-port)))))

(define (extract-instructions input)
  (map (lambda (expr)
         (match expr
           [(list x y)
            (let ([num-x (string->number x)]
                  [num-y (string->number y)])
              (* num-x num-y))]))
       (regexp-match* #rx"mul\\(([0-9]+),([0-9]+)\\)" input #:match-select rest)))

(define (process-instructions lines)
  (foldl + 0 (map (lambda (line) (foldl + 0 (extract-instructions line))) lines)))

(displayln (process-instructions get-input))
