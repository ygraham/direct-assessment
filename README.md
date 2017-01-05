# direct-assessment
Crowd-sourcing Direct Assessment Segment-level MT Evaluations

Instructions for Direct Assessment : Crowd-sourcing Segment-level Evaluations of MT output
-----------------------------------------------------------------------------------

Contact: graham.yvette@gmail.com

-----------------------------------------------------------------------------------

The following is a description of how to collect segment-level assessments
of translation adequacy on MTurk using methods described in the paper:

    Yvette Graham, Timothy Baldwin, Meghan Dowling, Maria Eskevich,
    Lamia Tounsi, Teresa Lynn. 2016. Is all that glitters in MT quality
    estimation really gold standard? In Proceedings of the 26th International
    Conference on Computational Linguistics, Osaka, Japan.
    https://www.computing.dcu.ie/~ygraham/grahametal-coling16.pdf

An updated version of the code published first in:

    Yvette Graham, Timothy Baldwin, Nitika Mathur. "Accurate Evaluation of
    Segment-level Machine Translation Metrics", NAACL 2015.
    https://www.computing.dcu.ie/~ygraham/grahametal-naacl15.pdf

The code is intended for use in combination with the MTurk web-based
requester user interface.

How to run:
--------------------

The code for collecting hits on MTurk is divided into two folders, one for
creating the files needed to run HITs and one for post-processing HITs.

To prepare the files for MTurk, go to folder "./prep-hits" and follow
the instructions below.

You need to downkload "arial.ttf" and place in ./prep-hits directory.

The following folder contains an example of how set-up expects text files
containing translations and reference translations to be located and named:

    ./data

The following command creates the necessary files for posting hits on MTurk
and places them in the directory "./out". Note that the command takes
approximately 4 minutes per 1000 sentences included due to the creation of
image files. It takes approximately 20 minutes in total to run on the example
data set:

    bash set-up-lp.sh cs en newstest2016 ad

./out should now contain the following:

    (1) a directory containing reference translation image files:
    ./out/img/ref/cs-en

    (2) a directory containing image files for the translations to be
    assessed by human judges (files named by randomly generated keys):
    ./out/img/ad/cs-en

    (3) A csv file of hits to be uploaded to MTurk:
    ./out/ad.mturk-hits.cs-en.csv

The folders containing the created image files should be placed in a
publicly visible folder with permissions changed as necessary to allow
all image files to be visible from the web. You can test this after
relocating the image files to an appropriate place by simply loading one
of the relocated image files in a browser.

Next, edit the MTurk source file:

    ./mturk-source-lps/mturk-to-en.html

so that the url in the MTurk code matches the urls of the public directory
where your image files are located. You will also need to change the
ref_dir and img_dir to point to the directories where you placed the
image files:

    var url = "http://computing.dcu.ie/~ygraham";
    var ref_dir = url+"/mturk/img/wmt/ref/"+SL+"-"+TL+"/"
    var img_dir = url+"/mturk/img/wmt/ad/"+SL+"-"+TL+"/"

In your MTurk requester account, go to

    > "Create" > "New Project" > "Other" > "Create Project"

Give your project a "Project Name", you can edit the other details in later.
Click on the

    "Design Layout" tab.

Click on

    "Source".

Select all of the source code displayed and replace with the MTurk code
you changed in this file:
    ./mturk-source-lps/mturk-to-en.html

    Click "Source" again.
    Click "Save".
    Click "Preview" - note the images won't display in the MTurk "preview" and
    the javascript click-through of 100 test items won't function properly, just
    ignore that for now.

    Click on "Create" tab to bring you back to a list of all your existing
    projects.

You should go back and edit the project to change the HIT fee payment,
the project description, etc.
When you are ready to post hits to MTurk workers, upload the csv file
by clicking "Publish Batch" beside the name of your project.
You'll be prompted to upload a csv file. Upload the following file:

    ./out/ad.mturk-hits.cs-en.csv

------------------------------------------------------------------------------
After HIT completion:
------------------------------------------------------------------------------

Go to directory

    ../proc-hits

Download the batch file of hits from MTurk and place in folder:

    ./batched-hits

The files should be named, e.g.:

    ./batched-hits/Batch_1234_batch_results.csv

Run the following command:

    bash proc-hits-step1.sh > out/step1

This creates some files in fold "./analysis". To find out which
workers have been flagged as possibly gaming the system type
the following:

    grep flag analysis/ad-wrkr-stats.csv

There are 4 ways a worker can be flagged, here's how to interpret:

    flag(scrs) : very close mean scores for badref / genuine system output / ref items
    flag(time) : very short time taken to complete at least one hit
    flag(seq)  : the worker gave constant ratings for a long sequence of translations at least once within a hit
    flag(rej)  : hits from this worker have previously been rejected

It is ultimately up to the individual researcher to decide which hits to
reject however.

Next, standardize the scores to remove differences in individual worker
scoring strategies:

    bash standardize-scrs.sh cs en > out/step2

When you have collected a minimum of 15 repeat assessments per segment,
compute mean scores per segment. The minimum sample size of repeat
assessments per segment is set to 15 and the script only produces scores
for segments with at least that number of repeat assessments. To compute
mean scores:

    bash score-segs-strict-unique.sh cs en > out/step3

This creates two files, one containing mean scores computed for segments
computed from raw scores provided by workers. The other is when scores
are standardized per worker mean and standard deviation of their overall
score distribution:

    ./analysis/ad-raw-seg-scores-1.es-en.csv
    ./analysis/ad-stnd-seg-scores-1.es-en.csv

The format in final scores files is as follows:

HIT N SID SYS SCR
H0 17 65 uedin-nmt 36.3088235294118

HIT: An id number used to identify hits to post on MTurk only

N: number of judgments combined to get the mean score for this segment (should be at least 15)

SID: the original sentence line number (one-based) in the input file
      (e.g. ../prep-hits/data/newstest2016/cs-en/newstest2016.cs-en.uedin-nmt)

SYS: Name of the system

SCR: Final DA score for the segment

Now you can compute correlations between these segment-level
scores and metric scores for evaluation of segment-level metrics.

... any questions, please contact graham.yvette@gmail.com

