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
;;   List: a list of 3D points.
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
;;   List P1: A list that represents the first point.
;;   List P2: A list that represents the second point. 
;;   List P3: A list that represents the third point. 
;;
;; Return:
;;   List: A list of four elements that represents a, b, c, and d
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
;; Description: Computes the distance between a point and a plane. (Helper)
;;
;; Input Parameters:
;;   List plane: A list of the a, b, c, and d values of
;;               that represent a plane in the form
;;               ax + by + cz = d.
;;   List point: A 3D point. 
;;
;; Return:
;;   Number: the distance between the point and the plane 
;;
;; -------------------------

(define (distance plane point)
  ( abs ( / ( + ( * (car plane) (car point) ) ( * (cadr plane) (cadr point) ) ; l = |a*x + b*y + c*z - d| / sqrt(a^2, b^2, c^2)
                ( * (caddr plane) (caddr point) ) ( * (cadddr plane) -1 ) )
            ( sqrt ( + ( * (car plane) (car plane) ) ( * (cadr plane) (cadr plane) ) ( * (caddr plane) (caddr plane) ) ) ) ) ) )

;; -------------------------
;;
;; Function: support
;;
;; Description: Creates the support of a plane.
;;
;; Input Parameters:
;;   List plane: A list of the a, b, c, and d values of
;;               that represent a plane in the form
;;               ax + by + cz = d.
;;   List points: A list of 3D points.
;;   Number eps: Represents the maximum distance a point can be from a plane
;;               for the point to be considered part of the plane. 
;;
;; Return:
;;   Pair: car is a number that represents the support counter,
;;         cdr is the plane parameters. 
;;
;; -------------------------

(define (support plane points eps)
  ( let ( (valid (filter (lambda(point) (< (distance plane point) eps)) points))) ; use filter to make a list of valid support points
       ( cons (length valid) plane ) ) ) ; return the length of the list of valid points in a pair with the plane equation

;; -------------------------
;;
;; Function: ransacNumberOfIteration
;;
;; Description: Perform numerous samples to find dominant plane. 
;;
;; Input Parameters:
;;   Number confidence: Represents the desired % chance of accurately
;;                      returning the dominant plane. 
;;   Number percentage: Represents the expected percentage of points
;;                      that are part of the dominant plane. 
;;
;; Return:
;;   Number: The number of iterations required for RANSAC.
;;
;; -------------------------

(define (ransacNumberOfIteration confidence percentage)
  ( ceiling ( / ( log ( - 1 confidence ) 10 ) ( log ( - 1 ( expt percentage 3 ) ) 10  ) ) ) ) ; equation to calculate confidence

;; -------------------------
;;
;; Function: dominantPlaneHelper
;;
;; Description: Perform numerous samples to find dominant plane. (Helper)
;;
;; Input Parameters:
;;    List Ps: A list of 3D points.
;;    Number k: The number of iterations required.
;;    Number eps: Represents the maximum distance a point can be from a plane
;;               for the point to be considered part of the plane.
;;    Pair best: Represents the best support for the plane
;;
;; Return:
;;   Pair: car is a number that represents the best support counter,
;;         cdr is the best plane parameters.  
;;
;; -------------------------

(define (dominantPlaneHelper Ps k eps best)
  (let ( (randomPoint1 (list-ref Ps (random (length Ps)))) ; find three random points
         (randomPoint2 (list-ref Ps (random (length Ps))))
         (randomPoint3 (list-ref Ps (random (length Ps)))) )
    (let ( (currPlane (plane randomPoint1 randomPoint2 randomPoint3) ) ) ; create the plane from these points
      (let ( (currSupport  (support currPlane Ps eps) ) ) ; calculate the support for this plane
        (cond
          ((= 0 k) best) ; if the number of iterations is reached, return the best plane found
          ((> (car currSupport) (car best) ) (dominantPlaneHelper Ps (- k 1) eps currSupport) ) ; if the new plane is better, recursively call with it as new best
          (else (dominantPlaneHelper Ps (- k 1) eps best))))))) ; else, recursively call with old best support as best

;; -------------------------
;;
;; Function: dominantPlane
;;
;; Description: Perform numerous samples to find dominant plane. 
;;
;; Input Parameters:
;;    List Ps: A list of 3D points.
;;    Number k: The number of iterations required. 
;;    Number eps: Represents the maximum distance a point can be from a plane
;;               for the point to be considered part of the plane.
;;
;; Return:
;;   List: The parameters '(a b c d) of the dominant plane. 
;;
;; -------------------------

(define (dominantPlane Ps k eps)
  (cdr (dominantPlaneHelper Ps k eps '(0 0 0 0 0)))) ; call a helper that tracks best support with an empty support - return the dominant plane

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
;;   Pair: car is the number of points of the dominant plane, cdr is the dominant plane equation
;;
;; -------------------------  

(define (planeRANSAC filename confidence percentage eps)
  ( let (( Ps (readXYZ filename)) ; read the points from the file into Ps
         ( k (ransacNumberOfIteration confidence percentage))) ; calculate the number of iterations required
     ( let (( domPlane (dominantPlane Ps k eps))) ; determine the dominant plane
        ( support domPlane Ps eps)))) ; find and return the support for the dominant plane
     
;; -------------------------
;;
;; Function: saveXYZ
;;
;; Description: Calculates the dominant plane equation and the number of points that
;;              supports it, and writes all points to a file.
;;
;; Input Parameters:
;;   String filenameIn: The name of the file to be processed.
;;   String filenameOut: The name of the file to be written to.
;;   Number confidence: Represents the desired % chance of accurately
;;                      returning the dominant plane. 
;;   Number percentage: Represents the expected percentage of points
;;                      that are part of the dominant plane. 
;;   Number eps: Represents the maximum distance a point can be from a plane
;;               for the point to be considered part of the plane. 
;;
;; Return:
;;   No explicit return - all points associated with dominant plane are written to a file.
;;
;; -------------------------  

(define (saveXYZ filenameIn filenameOut confidence percentage eps)
  (call-with-output-file filenameOut ; open file for writing
    (lambda(output-port) ; pass through the output-port
      ( let (( bestSupport (planeRANSAC filenameIn confidence percentage eps)) ; determine the dominant plane's support
             ( Ps (readXYZ filenameIn))) ; read in the points from the in-file
         ( let ( (valid (filter (lambda(point) (< (distance (cdr bestSupport) point) eps)) Ps))) ; use filter to make a list of valid support points
            (display bestSupport) ; send information about the plane to console
            (display "x\ty\tz" output-port) ; set the header
            (newline output-port)
            (for-each (lambda (point) ; write each point to the file
                      (display (car point) output-port)
                      (display " " output-port)
                      (display (car point) output-port)
                      (display " " output-port)
                      (display (car point) output-port)
                      (newline output-port))
                    valid))))))





     