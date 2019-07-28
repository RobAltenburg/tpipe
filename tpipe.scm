;;; tpipe
;;;
;;; Pipe fromSTDIN to the other (i.e. ".+") tmux window
;;; 
;;; R. Altenburg, 7/2019

(import shell)
(import (chicken io))
(import (chicken string))
(import (chicken port))
(import (chicken process-context))
(import args)

;; execute the tmux command on a line
(define (pipe-to-tmux line target)
  (let ((command (list (string-append "tmux send-keys -t " target " '" line "\n'"))))
    (execute command)))

;; read line from stdin
(define (loop-read in-line target)
  (unless (eof-object? in-line)
    (pipe-to-tmux in-line target)
    (loop-read (read-line) target)))

;; could test with (if (terminal-port? (current-input-port))
;; and do something different if you are interactive.

(define opts
  (list (args:make-option (t target) (optional: "TARGET") "target window or pane [default .+]")))

(let* ((arguments (args:parse (command-line-arguments) opts))
       (t-val (alist-ref 't arguments)))
  (if t-val
      (loop-read (read-line) t-val)
      (loop-read (read-line) ".+")))




;;(loop-read (read-line) ".+")
    
    

