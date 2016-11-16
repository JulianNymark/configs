(eval-after-load "go-mode"
  '(progn
     (define-key go-mode-map (kbd "C-c f")
       (lambda ()
         (interactive)
         (insert "func NAME(){

}")))
     (define-key go-mode-map (kbd "C-c m")
       (lambda ()
         (interactive)
         (insert "package main

import (
	\"log\"
)

func main() {
	log.Println(\"hello world!\")
}
")))
     (define-key go-mode-map (kbd "C-c g")
       (lambda ()
         (interactive)
         (gofmt)))))
