Name: Brent Palmer
Student Number: 300193610

Status of the project: All code complete and working. 

1 file, Project3.rkt, contains all code. 

Link to repo: https://github.com/BrentMRPalmer/Project-3

Test Cases:


Function: readXYZ
(readXYZ "Point_Cloud_1_No_Road_Reduced.xyz")
[outputs a lot of points]

Function: plane
(plane '(1 2 2) '(3 2 1) '(5 1 3))
(-1 -6 -2 -17)
(plane '(15 25 25) '(31 22 14) '(-5 12 32))
(-164 108 -268 -6460)

Function: distance
(distance '(-1 -6 -2 -17) '(5 6 7))
5.9346029517670305
(distance '(-164 108 -268 -6460) '(22 46 75))
36.96113533751999

