How to run the code

verifier.m, which
should be callable like this:
>> verifier(path-of-folds-file,	path-to-root-of-aligned-image-tree, path-for-output-file)
The output file pairs_out.txt produced by running the function verifier using the pairs.txt file. The format of this file is described below.

Project Description:
Our purpose is to build a face verification system. In the face verification problem, we are presented with two face images and must determine if they are of the same person or of
different people. We will evaluate the performance of our system using the Labeled Faces
in the Wild (LFW) benchmark from the University of Massachusetts.

The Dataset:
First, you should download the datase. There are 13,233 images of 5,749 people. The images we will use are the “LFW-a,” aligned versions of the original LFW images. LFW-a was produced by Lior Wolf, Tal Hassner, and Yaniv Taigman, and a brief description of the alignment procedure is available at http://www.openu.ac.il/home/hassner/data/lfwa/.

The folds file, pairs.txt, defines ten folds for the cross-validation experiment you will use to evaluate your system. This is a tab-delimited file. The first line indicates that there are 10 folds, each containing 300 “same” pairs and 300 “different” pairs.

10 300

The next 300 lines have three fields each, and define the “same” pairs in the first fold. For example, the first pair is described by the line

Abel_Pacheco 1 4

This indicates that the first “same” pair of the first fold consists of images 1 and 4 of Abel Pacheco. In the downloaded images directory, the paths to these files will be
Abel_Pacheco/Abel_Pacheco_0001.jpg and Abel_Pacheco/Abel_Pacheco_0004.jpg. After the 300 lines describing “same” pairs, there are 300 lines describing the “different” pairs
in the first fold. The first of these is

Abdel_Madi_Shabneh 1 Dean_Barker 1

This indicates that the first “different” pair of the first fold is the images
Abdel_Madi_Shabneh/Abdel_Madi_Shabneh_0001.jpg and Dean_Barker/Dean_Barker_0001.jpg.
After the 600 lines that describe fold 1, there are 600 lines for fold 2, 600 lines for fold 3, etc. up to fold 10. There is a matlab function to parse this file, read_lfw_folds(). Our program WILL read this file and perform the cross-validation experiment. First train on Folds 2-10 and evaluate the pairs in fold 1, then train on folds 1 and 3-10 and evalute on fold 2,etc. My program will output a file that is a copy of pairs.txt, but with each line except the first prefixed by a decision value and an additional tab character. A positive decision value indicates that your program classifies this as a “same” pair, and a negative value indicates that it is a “different” pair. For example the first two lines of output might be

10 300
1.1211 Abel_Pacheco 1 4
-0.2455 Akhmed_Zakayev 1 3

if my classifier decides that the first pair is “same” (correct) and the second pair is different
(incorrect).