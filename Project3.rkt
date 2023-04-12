;; -------------------------
;;
;; Student Name: Brent Palmer
;; Student Number: 300193610
;;
;; -------------------------

#lang scheme

;; -------------------------
;;
;; Function: readXYZ
;;
;; Description: Reads the point cloud in a file and creates a list of 3D points.
;;
;; Input Parameters:
;;   String fileIn: The name of the file to be processed.
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

;; -------------------------
;;
;; Function: plane
;;
;; Description: Computes a plane equation from 3 points.
;;              The equation is described by a list of the four parameters,
;;              from the equation ax + by + cz = d.
;;
;; Input Parameters:
;;   list P1: A list that represents the first point.
;;   list P2: A list that represents the second point. 
;;   list P3: A list that represents the third point. 
;;
;; Return:
;;   list: A list of four elements that represents a, b, c, and d
;;         from the equation outlined in the description.
;;
;; -------------------------

(define (plane P1 P2 P3)
  ( let (( x1 ( - (car P2) (car P1) ) ) ; calculating vector 1
         ( y1 ( - (cadr P2) (cadr P1) ) )
         ( z1 ( - (caddr P2) (caddr P1) ) )
         ( x2 ( - (car P3) (car P1) ) ) ; calculating vector 2
         ( y2 ( - (cadr P3) (cadr P1) ) )
         ( z2 ( - (caddr P3) (caddr P1) ) ))
           ( list ( - ( * y1 z2) (* z1 y2) ) ; create list of '(a, b, c, d), starting with calculating a
                   ( - ( * z1 x2) (* x1 z2) ) ; calculating b
                   ( - ( * x1 y2) (* y1 x2) ) ; calculating c
                   ( + ( * ( - ( * y1 z2) (* z1 y2) ) (car P3) ) ; calculating d
                       ( * ( - ( * z1 x2) (* x1 z2) ) (cadr P3) )
                       ( * ( - ( * x1 y2) (* y1 x2) ) (caddr P3) )))))

;; -------------------------
;;
;; Function: distance
;;
;; Description: Computes the distance between a point and a plane. (helper)
;;
;; Input Parameters:
;;   list plane: A list of the a, b, c, and d values of
;;               that represent a plane in the form
;;               ax + by + cz = d.
;;   list point: A 3D point. 
;;
;; Return:
;;   number: the distance between the point and the plane 
;;
;; -------------------------

(define (distance plane point)
  ( abs ( / ( + ( * (car plane) (car point) ) ( * (cadr plane) (cadr point) )
                ( * (caddr plane) (caddr point) ) ( * (cadddr plane) -1 ) )
            ( sqrt ( + ( * (car plane) (car plane) ) ( * (cadr plane) (cadr plane) ) ( * (caddr plane) (caddr plane) ) ) ) ) ) )

;; -------------------------
;;
;; Function: support
;;
;; Description: Creates the support of a plane.
;;
;; Input Parameters:
;;   list plane: A list of the a, b, c, and d values of
;;               that represent a plane in the form
;;               ax + by + cz = d.
;;   list points: A list of 3D points.
;;   Number eps: Represents the maximum distance a point can be from a plane
;;               for the point to be considered part of the plane. 
;;
;; Return:
;;   pair: car is a number that represents the support counter,
;;         cdr is the plane parameters. 
;;
;; -------------------------

(define (support plane points eps)
  ( let ( (valid (filter (lambda(point) (< (distance plane point) eps)) points)))
       ( cons (length valid) plane ) ) )

;; -------------------------
;;
;; Function: planeRANSAC
;;
;; Description: Calculates the dominant plane equation and the number of points that
;;              supports it.
;;
;; Input Parameters:
;;   String filename: The name of the file to be processed.
;;   Number confidence: Represents the desired % chance of accurately
;;                      returning the dominant plane. 
;;   Number percentage: Represents the expected percentage of points
;;                      that are part of the dominant plane. 
;;   Number eps: Represents the maximum distance a point can be from a plane
;;               for the point to be considered part of the plane. 
;;
;; Return:
;;   pair: car is the dominant plane equation, cdr is the number of points that supports it
;;
;; -------------------------  

;; (define (planeRANSAC filename confidence percentage eps)
;;  ( let (( Ps (readXYZ filename))) ; read the points from the file into Ps
;;     (let ( (randomPoint1 (list-ref Ps (random (length Ps)))) ; find the three random points
;;            (randomPoint2 (list-ref Ps (random (length Ps))))
;;            (randomPoint3 (list-ref Ps (random (length Ps))))
;;     ))))















     