;;; tpipe
;;;
;;; Pipe fromSTDIN to the other (i.e. ".+") tmux window
;;; 
;;; R. Altenburg, 7/2019

(import shell)
(import (chicken io))
(import (chicken string))
(import (chicken port))

;; execute the tmux command on a line
(define (pipe-to-tmux line)
  (let ((command (list (string-append "tmux send-keys -t .+ '" line "\n'"))))
    (execute command)))

;; read line from stdin
(define (loop-read in-line)
  (unless (eof-object? in-line)
    (pipe-to-tmux in-line)
    (loop-read (read-line))))

;; could test with (if (terminal-port? (current-input-port))
;; and do something different if you are interactive.

(loop-read (read-line))
    
    

