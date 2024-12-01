#lang racket

(define input-lines
  (with-input-from-file "input.txt"
    (lambda ()
      (port->lines (current-input-port)))))

(for-each displayln input-lines)