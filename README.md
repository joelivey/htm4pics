htm4pics
========

Application to generate html for images and videos in a directory hierarchy\

This is software that I have worked on since 2001, mainly providing friends and family with CDs and DVDs 
containing pictures and videos that I had taken and structured under one top directory.  After the first 
few modifications, I put a 30 image limit on the number that would display in a single page, since images 
had gotten to be very large, and 50 to 100 images on the same page at very large dimensions ate up people's 
systems.  Currently, it uses thumbnails if they are available (and I do recommend them) for display on the 
page with lots of images, and then displays the full image only when specifically requested by the user 
going from the small image at the top of the page, to larger image down further, and finally clicking on 
that larger image to launch the full image.

I have used the PerlApp functionality in ActiveState's Perl Developer Kit to generate an htm4pics.exe 
application that is totally contained, so my friends that wanted to use the htm4pics application on Windows
systems did not need to have Perl installed or know how to use Perl scripts.  That is how the htm4pics.exe 
in the repository was generated.

Htm4pics does operate from a single top directory, which shouldn't contain more than 30 images, and handles all 
of the directories which are under it.

One can add comments to an image or video by giving a text file the same name as the image or video, but a 
.txt extension.  If desired, html can be inserted into these comments.

Enjoy.
