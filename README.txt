Name: Brent Palmer
Student Number: 300193610

Status of the project: All code complete and working. 

1 file, Project3.rkt, contains all code. 
4 files, Point_Cloud_1_No_Road_Reduced.xyz, Point_Cloud_2_No_Road_Reduced.xyz
         Point_Cloud_3_No_Road_Reduced.xyz, PointCloud1.xyz
	 store the respective original point clouds. PointCloud1.xyz is used
         to provide a reference point for comparison with projects parts 1 and 2
         to assess accuracy. 
4 files, Point_Cloud_1_No_Road_Reduced_p1.xyz, Point_Cloud_2_No_Road_Reduced_p1.xyz
         Point_Cloud_3_No_Road_Reduced_p1.xyz, PointCloud1_p1.xyz
         include the dominant point clouds of each of the respective point clouds. 
1 file, Part 3.pdf is included for reference to instructions. 

The return values of saveXYZ (which is just planeRANSAC with extra steps) are outlined here for the four point clouds:
Confidence: 0.99 Percentage: 0.5 Eps: 0.5
> (saveXYZ "PointCloud1.xyz" "PointCloud1_p1.xyz" 0.99 0.5 0.5)
(37259 -2.667909382406669 -5.797185344417666 107.1379518764675 -70.74330099183318)
> (saveXYZ "Point_Cloud_1_No_Road_Reduced.xyz" "Point_Cloud_1_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
(1996 -22.014001295009145 -58.18670152233863 278.7955571728768 -46.5073213165604)
> (saveXYZ "Point_Cloud_2_No_Road_Reduced.xyz" "Point_Cloud_2_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
(3368 -0.9873339576729165 5.783786779100219 55.20996334891797 27.708609368792857)
> (saveXYZ "Point_Cloud_3_No_Road_Reduced.xyz" "Point_Cloud_3_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
(3027 -18.293004453265823 1.4203681782879158 104.93193539320124 125.87494756815676)


NOTE: I implemented an additional function called SaveXYZ that both executes planeRANSAC and 
saves the points to a file. I did not add the saving to planeRANSAC itself, as Scheme
does not overwrite files. Manual deletion is a hassle, so this modularity allows for
quick successive runs of planeRANSAC for testing. 

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
(distance '(-1 -6 -2 -17) '(1 2 3))
0.31234752377721214
(distance '(-1 -6 -2 -17) '(4 5 6))
4.529039094769575
(distance '(-1 -6 -2 -17) '(-1 0 1))
2.498780190217697

Function: support
(support '(-1 -6 -2 -17) '((1 2 3) (4 5 6) (-1 0 1)) 4)
(2 -1 -6 -2 -17)

Function: ransacNumberOfIteration
(ransacNumberOfIteration 0.99 0.5)
35.0

Function: dominantPlane
(dominantPlane (readXYZ "Point_Cloud_1_No_Road_Reduced.xyz") 35 1.2)
[some equation parameters]

(dominantPlane (readXYZ "PointCloud1.xyz") 35 0.5)
[some equation parameters]

Function: planeRANSAC
(planeRANSAC "PointCloud1.xyz" 0.99 0.5 0.5)
~36k points, [some equation parameters]
(planeRANSAC "Point_Cloud_1_No_Road_Reduced.xyz" 0.99 0.5 0.5)
~2k points, [some equation parameters]
(planeRANSAC "Point_Cloud_2_No_Road_Reduced.xyz" 0.99 0.5 0.5)
~3k points, [some equation parameters]
(planeRANSAC "Point_Cloud_3_No_Road_Reduced.xyz" 0.99 0.5 0.5)
~3k points, [some equation parameters]


Function: saveXYZ
(saveXYZ "PointCloud1.xyz" "PointCloud1_p1.xyz" 0.99 0.5 0.5)
~36k points, [some equation parameters] 
Also writes to a file.
(saveXYZ "Point_Cloud_1_No_Road_Reduced.xyz" "Point_Cloud_1_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
~2k points, [some equation parameters]
Also writes to a file.
(saveXYZ "Point_Cloud_2_No_Road_Reduced.xyz" "Point_Cloud_2_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
~3k points, [some equation parameters]
Also writes to a file.
(saveXYZ "Point_Cloud_3_No_Road_Reduced.xyz" "Point_Cloud_3_No_Road_Reduced_p1.xyz" 0.99 0.5 0.5)
~3k points, [some equation parameters]
Also writes to a file.



