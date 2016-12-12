# direct-assessment
Direct Assesment for Human Evaluation of MT
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

... under construction 
