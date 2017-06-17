(eval-after-load "go-mode"
  '(progn
     (define-key go-mode-map (kbd "C-c f")
       (lambda ()
         (interactive)
         (insert "func NAME(){

}")
         (gofmt)))
     (define-key go-mode-map (kbd "C-c m")
       (lambda ()
         (interactive)
         (insert "package main

import (
\"log\"
)

func main() {
log.SetFlags(log.LstdFlags | log.Lshortfile)
log.Println(\"hello world!\")
}
")
         (gofmt)))
     (define-key go-mode-map (kbd "C-c g")
       (lambda ()
         (interactive)
         (gofmt)))
     (define-key go-mode-map (kbd "C-c e")
       (lambda ()
         (interactive)
         (insert "if err != nil {
log.Panic(err)
}
")
         (gofmt)))
     ))
