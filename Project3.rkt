;; -------------------------
;;
;; Student Name: Brent Palmer
;; Student Number: 300193610
;;
;; -------------------------  

;; -------------------------
;;
;; Function: readXYZ
;;
;; Description: Reads the point cloud in a file and creates a list of 3D points.
;;
;; Input Parameters:
;;   String literal fileIn: The name of the file to be processed.
;;
;; Return:
;;   list: a list of 3D points.
;;
;; -------------------------   

(define (readXYZ fileIn)
 (let ((sL (map (lambda s (string-split (car s)))
                (cdr (file->lines fileIn)))))
   (map (lambda (L)
          (map (lambda (s)
                 (if (eqv? (string->number s) #f)
                     s
                     (string->number s))) L)) sL)))