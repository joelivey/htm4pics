htm4pics (c) 2001-2014, joel ivey (jivey@jiveysoft.com)

With the advent of digital cameras, scanners, and images returned from
developing on CD-Roms, it is possible to have a large number of
personal images which one would like to share with family and friends. 
However, simply handing them a CD-Rom with a series of directories
full of, frequently very large, images is not kind.  There are
software packages which generate thumbnails to view, but frequently
these are too small and/or require special software to be viewed.

To solve this problem htm4pics was written.

This is a standalone application which processes all directories
beneath a specified directory and identifies image and media files
present and generates a series of html files or webpages for them. 
The primary file 'main.html' is placed in the specified directory. 
All other html files are placed in a directory 'htmls' in that
directory.

When the 'main.html' file is opened in a web browser, it will list the
directories immediately beneath it and then display 'smaller' images
of any files in that directory (video and audio files, if present, are
indicated by  a 'film' and 'audio' icons and can be played by clicking
on them).  If one of the small images is clicked on, or the webpage is
scrolled down, it will display a series of 'larger' images of the
files.  If one of these images is clicked on, it will display the
image in its original size.  While the images are indicated as
'smaller' and 'larger', the actual size will be determined by height
of the webbrowser, since the 'smaller' images will be shown at 40% of
the height and 'larger' images will be shown at 90% of the height. 
Thus, if you want to see many more smaller images in one glance,
simply have the web browser cover less vertical space.

Even though a picture may be worth a thousand words, sometimes simply
looking at the pictures doesn't convey what they really mean, or where
or when they were taken, etc.  It is also possible to add textual
information as comments and descriptions with html4pics.  If a file
'comment.txt' is present in a directory, its contents will be
displayed at the top of the web page for that directory.  If an image
file and a text file (.txt) with the same base name exist, such as
Halloween.jpg and Halloween.txt, the contents of the text file
(Halloween.txt) will be displayed immediately under the 'larger' image
with the same name (Halloween.jpg).

A large number of images in a single webpage, especially large images,
can eat up very large amounts of memory as it displays the images.  To
minimize this potential problem, htm4pics has been set up to include a
maximum of 30 images in a single page.  If there are more images, they
are included in additional html pages with the same name but an
underscore and number is appended to the name.  In this case, there
are links to 'Next' between the 'smaller' and 'larger' images, and at
the bottom of the page (there are also links to 'Home' in these
locations which will take you back to main.html).

For larger images from some of the current digital cameras, even the
reduction of the number of images in a given page to 30, still
resulted in sizes too large for some older machines.  I have found
that a free program Easy Thumbnails by Fookes Software
(http://www.fookes.com/ezthumbs/?3.0) can be used to generate
thumbnails of the larger images.  If the setting is for the prefix
tn_, htm4pics will identify the relationship between thumbnails and
large images, and the thumbnails will be used for the initial small
and large images, while the full size image is opened if the user
clicks on the large image.  For my large images (approximately 1200 x
1600 pixels [that was in 2001, now they are 2816 x 2112]), I use Easy
Thumbnails to generate 640 x 640 thumbnails (well, they are smaller
than the originals ;-).  The thumbnails should be generated in the
same directory as the large images, and if comments for the images are
used they should have filenames in the format tn_filename.txt.

The program now correctly handles situations where subdirectories with
the same name may appear under different trees under the primary
directory.

Only directories which contain image/media files or subdirectories
which contain image/media files appear in the web pages generated.

The program has also been modified to indicate the number of images in
a directory (or in the first and continuation directories if more than
30).



Installation.

Unzip the provided zip file, htm4pics.zip, using winzip or a similar
zip file accessory into a directory.  If the directory is one that is
on the system path you won't need to specify a directory when you use
it.

The zip file contains the following files:

htm4pics.exe - the application itself

readme-htm4pics.txt - the file you are reading

image1.gif - a small image used to represent video files image2.gif -
a larger image of the icon image3.gif - a still larger image of the
icon - this is the one currently used audio.gif  - a small image used
to represent audio files audio3.gif - a still larger image of the icon
- this is the one currently used

showpics.exe - a startup file for use on CDs if you want them to see
the main.html file on startup.

autorun.inf - the file which, on a CD, will cause it to autostart if 
autostart is turned on.  This is simply a text file which causes 
showpics.exe to start with the argument main.html

If you are going to use the program with a CD, and the specified
directory will be the top of the CD, the autorun.inf and showpics.exe
files in that directory cause the main.html file to be opened and
displayed in a browser when the CD is put into the machine.  Delete
these two files from that directory if you do not want this
functionality (some people may not want their files popping open for
everyone to see).




Using htm4pics.

1) Within My Computer or Windows Explorer or similar applications you
can browse to the directory where you installed htm4pics and double
click on the file name or icon.  or 2) Within Windows Explorer you can
also select the File|Run and then type in htm4pics if it was installed
on the system path, or c:\directory\htm4pics (where c:\directory
represents the path used to unzip htm4pics) and click on OK. or 3) You
can open a Dos or Command window and at the prompt type in the path
and filemame htm4pics and enter return.

In cases 1 and 2 above, a Command window will open (3 already has it
open) and display a copyright message and the prompt

Directory to process:

type in the path to the top directory you want to use (e.g.,
C:\MyPics2000) and press the Enter key.  You will then be prompted as
to whether or not you need to make thumbnails.  If you respond Y(es), the
application will terminate and expect you to restart after the
thumbnails have been generated.  If the thumbnails are completed, you
will be prompted for a title to be put on the web pages, and then
asked whether that is correct.

Immediately beneath the prompt it will flash the message
'---analyzing---' while it is gathering file names, etc., then it will
flash '---writing---' while it is actually generating the html files. 
The '---analyzing---' portion is the majority of the time, and the
time between flashes depends on the number of files in a specific
directory.  If one or more media files were included in the html pages
generated, the 'movie1.gif' file will automatically be copied into the
htmls directory.

After the processing has completed in cases 1 and 2, the command box
will prompt you to enter RETURN to terminate.  In case 3, you will
also be asked to RETURN to terminate and then be returned to the
command prompt.

The amount of time required to process the files depends, of course,
on how many files are included beneath the directory and the machine's
speed.  For 10,000 or so files, you can expect the program to take
from 1 to 3 minutes to complete depending on the speed of the machine.

 