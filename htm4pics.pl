
# htm4pics.pl  -- program to generate html for a directory with JPEG images
#                      in that or in subdirectories.  It will create a main.html 
#
# usage  perl htm4pics.pl c:\dir\
#
# where C:\dir\ is the location of the files to be referenced

# version 1.20 
# corrected to handle multiple subdirectories with the same name
# version 1.24
# modified to handle mp4 video files

use strict;
use warnings;
use File::Copy;

my @jpegs = ();
my @comment = ();
my @dirs = ();
my @files = ();
my $njpg = 0;
my $ndirs = 0;
my @jpgcnt = ();
my ($dircnt, $filen, $iparent, $filecurr);
my ($path, $program, $videoseen, $audioseen, $filenamep, $kval);
my @txtsort = ();
my ($line, $kfile, $tnfile, $jpgmax, $jpgcnt, $jval, $maxfilen);
my ($ktext, $filecurra, $ival, $filedir, $filename, $filename1);
my ($filenametn, $filenamex, $ftype, $file1, $mfile, $njpgs, $kstr);
my @jpgsort = ();
my @dirtot = ();
my @htmlname;
my @dirname;
my %parent;
my @jpegname;
my @textfile;
my @thumbs;
my @tn;
my (@dirscnt, @jpegcnt, %jpegname, %textfile, %dirhash, %thumbs);
my ($filecurr1, $letter, $letter1, $filelen, $jival, $key, $tnameval);
my ($tnameval1, $dirsval, $htmlnamep, $dirloc, $jfilevalue);
my (%jpegs, %texts, %jpgperdir, %tn);
my ($headername, $maintitle);
my $dirs0length;
my $maxpages;
my $jpegnfiles;


print "htm4pics version 1.24 (c) 2001-2014, joel ivey  (jivey\@jiveysoft.com)\n\nDirectory to process: ";
$_ = <STDIN>;
chop;
my $file = $_;
@files = ($file); # = (shift(@ARGV));

print "Do you need to make thumbnails for images (Y/N)?"; # 101024 JLI
if (<STDIN> =~ /[Yy].*/) {
  exit;
}
$_ = "N";
while (! ($_ =~ /[Yy].*/)) {
  print "\nWhat do you want the main title to be? ";
  $_ = <STDIN>;
  chop;
  $maintitle = $_;
  print "The main title will be:\n   $maintitle\nCorrect (Y/N)? ";
  $_ = <STDIN>;
}

my $nfiles = 0;
my $jpgcnt1;

my $oldfile = '';
my $ifile = -1;
foreach $file (@files) {
  if ( $oldfile ne '' ) {
    $jpgperdir{$oldfile} = $jpgcnt1 + 1;
  }
  $oldfile = $file;
  $nfiles = 0;
  $dirscnt[++$ifile] = $ndirs;
  $jpgcnt[$ifile] = $njpg;
  $comment[$ifile] = '';
  $jpgcnt1 = -1;
  $jpegcnt[$ifile] = $jpgcnt1;
  $dircnt = 0;
  $dirtot[$ifile] = 0;
  %jpegname = ();
  %textfile = ();
  %thumbs = ();
  print "---analyzing $ifile---\n";
	
  if ( $ifile == 0) {
    if ( ! ($file =~ /\/$/) ) {
      $file = $file . '/';
    }
    $dirs[$ndirs++] = $file;
    $dirs0length = length $file;
    $filelen = length $file;
    $filedir = $file . 'htm4pics';
    mkdir $filedir;
    opendir(HOMEDIR, $filedir);
    # clean out any current entries in htm4pics directory
    while ($filename = readdir(HOMEDIR)) {
      if ( ! (($filename eq '..') || ($filename eq '.')) ) {
	unlink( "$filedir/$filename");
      }
    }
  }
  opendir(HOMEDIR, $file) || die("couldn't open $file.");
  while ($filename = readdir(HOMEDIR)) {
    if ($file ne $dirs[0]) {
      $filename1 = $file . '/' . $filename;
    }
    else {
      $filename1 = $file . $filename;
    }
    if (! ($filename =~ /[Tt][Nn]\_.*/) ) {
      $filenametn = $file . '/' . 'tn_' . $filename;
      if ($filename =~ /comment.txt$/i ) {
	$comment[$ifile] = $filename1;
      }
      if ( $filename =~ /\.(jpg|gif|png|jpeg|avi|mpg|wmv|mpeg|mp4|rm|mov|au|ram|ra|asf|wav|mp3)/i ) {
	$nfiles++;
	$jpegname[$ifile][++$jpgcnt1] = $filename1;
	$textfile[$ifile][$jpgcnt1] = '';
	if (-e $filenametn ) {
	  $thumbs[$ifile][$jpgcnt1] = $filenametn;
	}
	else {
	  $thumbs[$ifile][$jpgcnt1] = $filename1;
	}
	if ( $filename1 =~ /(.+)\.(jpg|gif|png|avi|mpg|wmv|mpeg|mp4|jpeg|rm|mov|au|ram|ra|asf|wav|mp3)/i ) {
	  $filenamex = $1 . '.txt';
	  if (-e $1.'.txt') {
	    $textfile[$ifile][$jpgcnt1] = $filenamex;
	  }
	}
	$jpegcnt[$ifile] = $jpgcnt1;
      }
    }
    $ftype = '';
    $file1 = '';
    if (-d $filename1) {
      $ftype = '  dir';
      if (($filename ne '.') && ($filename ne '..') && ($filename ne 'htm4pics')) {
	if ( checkdirs($filename1) > 0 ) {
	  $nfiles++;
	  @files = (@files, $filename1);
	  $dirs[$ndirs++] = $filename1;
	  $dirname[$ifile][$dircnt++] = $filename1;
	  $dirtot[$ifile] = $dircnt;
	  $parent{$filename1} = $ifile;
	  $mfile = $parent{$filename1};
	  $mfile = $ifile;
	}
      }
    }
  }
  closedir(HOMEDIR);
  #  if ($nfiles == 0 ) { $ifile--; }
}
$jpgperdir{$oldfile} = $jpgcnt1+1;

$dirscnt[++$ifile] = $ndirs;
$jpgcnt[$ifile] = $njpgs;
# foreach $key (keys %parent) {
#  $jfilevalue = $key;
# }

$audioseen = 0;
$videoseen = 0;

for ($ival = $ifile-1; $ival >= 0; $ival--) {
  if ($ival % 2) {
    print "---writing---\n";
  }
	
  if ($ival == 0) {
    $file = $dirs[0] . 'main.html';
    $filecurr = 'main';
    $kstr = '.';
  }
  else {
    if ( $dirs[$ival] =~ /\/([^\/]+$)/ ) {
      $filecurr = $1;
      $filecurra = $filecurr;
      $filecurr1 = $filecurr . '_';
      $letter = 64;
      $letter1 = 64;
      $file = $dirs[0] . "htm4pics/$filecurr.html";
      while (-e $file) {
	$letter++;
	if ( $letter > 90 ) {
	  $letter1++;
	  $filecurr1 = $filecurr . '_' . chr($letter1);
	  $letter = 65;
	}
	$filecurra = $filecurr1 . chr($letter);
	$file = $dirs[0] . "htm4pics/$filecurra.html";
      }
      for ($jival=0 ; $jival<$ifile-1; $jival++) {
	for ($kval=0; $kval < $dirtot[$jival]; $kval++) {
	  if ( $dirname[$jival][$kval] eq $dirs[$ival] ) {
	    $htmlname[$jival][$kval] = $filecurra;
	  }
	}
      }
      $kstr = '..';
    }
  }
  open(OFIL, '>' . $file);
  $maxpages = 0;
  my $pagenumber = 0;
  my $totalimages = $jpegcnt[$ival];
  if ($jpegcnt[$ival] > 0) {
    $maxpages = ($jpegcnt[$ival] / 30);
    if ($jpegcnt[$ival] % 30) {
      $maxpages = (($jpegcnt[$ival] - ($jpegcnt[$ival] % 30)) / 30) + 1;
    }
  }
  my $num = '';
  if ($maxpages > 1) {
    $num = '&nbsp;&nbsp;1 of ' . $maxpages;
  }
  #$headername = 'Images from ' . substr($dirs[$ival],length($dirs[0])-1,length($dirs[$ival]));
  my $headerdir = substr($dirs[$ival],length($dirs[0])-1,length($dirs[$ival]));
  while ($headerdir =~ /([^\/]*)\/(.*)/){
    if (length($1) == 0) {
      $headerdir = $2;
    }
    else {
      $headerdir = "$1 \- $2";
    }
  }
  $headername = $maintitle;
  if (length($headerdir) > 0) {
    $headername = "$headername - $headerdir";
  }
  print OFIL "<html><head>\n<title>$headername$num</title></head><body>\n";
  if ($ival == 0) {
    print OFIL "<br>Click on a small image and you will be taken further down the page to see a larger version of the image.  If you click on that one, you will be taken to the full size image, where you can use the scroll bars to move around the high resolution image.<br><br>\n";
  }

  my %jpghash;
  foreach $key (keys %dirhash) {
    delete $dirhash{$key};
  }
  for ($kval=0; $kval < $dirtot[$ival]; $kval++) {
    $tnameval = $dirname[$ival][$kval];
    my $jpegnfiles = $jpgperdir{$tnameval};
    $tnameval1 = $tnameval;
    # if not thumbnail, add tn_ to name to set order
#    if (! ($tnameval1 =~ /^.*\/[Tt][Nn]\_([^\/]+)$/ ) ) {
#      my $text = $tnameval1;
#      if ($text =~ /^(.*\/)([^\/]+)$/) {
#	$tnameval1 = $1 . "tn_" . $2;
#      }
#    }
    $tnameval1 =~ tr/A-Z/a-z/;
    $dirhash{$tnameval1} = $htmlname[$ival][$kval];
    $jpghash{$tnameval1} = $jpegnfiles;
  }
  if ($comment[$ival] ne '') {
    print OFIL "<p>\n";
    $filenamep = '<' . $comment[$ival];
    open(INFIL, $filenamep);
    while (<INFIL>) {
      print OFIL "<br>$_";
    }
    print OFIL "<p>";
    close(INFIL);
  }
  if (($ival == 0) && ($maxpages > 1)) {
    my $line = "<br>$maintitle (starting this page)&nbsp;&nbsp;&nbsp;($totalimages items)\n";
    print OFIL $line;
    for (my $i=2; $i<=$maxpages; $i++) {
      my $numval = $i - 1;
      my $dir = ".\/htm4pics\/main\_$numval.html";
      $dir =~ tr$\\$/$;
      $line = "<br><a href=$dir>$maintitle\_$numval<\/a>\n";
      print OFIL $line;
    }
  }
  foreach $dirsval (sort keys(%dirhash)) {
    if ($dirsval =~ /\/([^\/]+)$/ ) {
      $filenamep = $1;
      $htmlnamep = $dirhash{$dirsval};
      $dirloc = '';
      if ($ival == 0) {
	$dirloc = '/htm4pics';
      }
      my $ajpgcnt = '';
      if ( defined $jpghash{$dirsval} ) {
        if ( $jpghash{$dirsval} > 1 ) {
          $ajpgcnt = '&nbsp;&nbsp;&nbsp;(' . $jpghash{$dirsval} . ' items)';
        }
        elsif ( $jpghash{$dirsval} == 1 ) {
          $ajpgcnt = '&nbsp;&nbsp;&nbsp;(' . $jpghash{$dirsval} . ' item)';
        }
      }
      $line = "<br><a href=\".$dirloc\/$htmlnamep.html\">$filenamep<\/a>$ajpgcnt\n";
      $line =~ tr$\\$/$;
      print OFIL $line;
      }
    }
    %jpegs = ();
    %texts = ();
    %tn = ();
    if ($jpegcnt[$ival] >= 0) {
      for ($kval = 0; $kval <= $jpegcnt[$ival]; $kval++) {
	$kfile = $kstr . substr($jpegname[$ival][$kval],$filelen-1);
	$jpegs{$kfile} = '';
	$texts{$kfile} = $textfile[$ival][$kval];
#	$tn{$kfile} = $thumbs[$ival][$kval];
	$tn{$kfile} = $kstr . substr($thumbs[$ival][$kval],$filelen-1);
      }
      $jpgcnt = 0;
      @jpgsort = ();
      @txtsort = ();
      my @thumbsort = ();
      foreach $kfile (sort keys(%jpegs)) {
	$jpgsort[$jpgcnt] = $kfile;
	$thumbsort[$jpgcnt] = $tn{$kfile};
	$txtsort[$jpgcnt++] = $texts{$kfile};
#	my $sortname = $kfile;
#	if (! ($kfile =~ /^[Tt][Nn]\_/)) {
#	  $sortname = "tn_$sortname";
#	}
#	$filesort{$sortname} = $kfile;
      }
      my $pagenumber = 0;
      for ($jval=0; $jval < $jpgcnt; $jval=$jval+30) {
	$pagenumber = $jval/30;
	$jpgmax = $jval + 29;
	if ($jpgmax >= $jpgcnt) {
	  $jpgmax = $jpgcnt-1;
	}
	if ($jval > 0) {
	  $filen = $jval / 30;
	  $maxfilen = ($jpgcnt / 30);
	  if ($jpgcnt % 30) {
	    $maxfilen = (($jpgcnt - ($jpgcnt % 30)) / 30) + 1;
	  }
	  my $maxfilelen = length($maxfilen);
	  $filen = '0000' . $filen;
	  $filen = substr($filen, -$maxfilelen, 5);
	  $file = $dirs[$ival];
	  if ($ival == 0) {
	    $filecurra = 'main';
	    $filecurr = $filecurra . '_' . $filen;
	  }
	  if ($file =~ /\\([^\\]+)$/ ) {
	    $filenamep = $1;
	    $line = "<br><a href=\".\\$filecurra\_$filen.html\">Next<\/a>\n";
	    $line =~ tr$\\$/$;
	    print OFIL $line;
	  }
	  if ($ival == 0 && $filen > 0  && $filen < $maxpages) {
	    my $dir = '.';
	    if ($pagenumber == 1) {
	      $dir = '.\htm4pics';
	    }
	    $line = "<br><a href=\"$dir\\$filecurra\_$pagenumber.html\">Next<\/a>\n";
	    $line =~ tr$\\$/$;
	    print OFIL $line;
	  }
	  if ( (! ($ival == 0) ) || $jval > 0) {
	    if ($ival == 0 && $pagenumber == 1) {
	    }
	    else {
	      $line = "<br><a href=\"..\\main.html\">Home<\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	  }
	  print OFIL "<br><br><br><h7>Generated with htm4pics (www.jiveysoft.com)</h7>\n";
	  print OFIL "<\/body><\/html>\n";
	  close OFIL;
	  $filecurr = $filecurra;
	  $pagenumber++;
	  if ($filen > 0) {
	    $filecurr = $filecurra . '_' . $filen;
	  }
	  if ($jval > 0) {
	    if ($ival == 0) {
	      $line = "$dirs[0]htm4pics\\main\_" . ($jval/30). "\.html";
	      open(OFIL, ">$line" );
	      $headername = $maintitle;
	    }
	    else {
	      open(OFIL, ">$dirs[0]htm4pics\\$filecurr.html");
	    }
	    my $num = '';
	    if ($maxpages > 1) {
	      $num = $filen + 1;
	      $num = "&nbsp;&nbsp;$num of $maxpages";
	    }
	    print OFIL "<html><head>\n<title>$headername $num</title></head><body>\n";
	  }
	  foreach $key (keys %parent) {
	    $jfilevalue = $key;
	  }
	  if (! ($ival == 0) ) {
	    $iparent = $parent{$file};  #namex};
	    $dircnt = $dirtot[$iparent];
	    if ($filen > 0) {
	      $dirname[$iparent][$dircnt] = $file . '_' . $filen;
	    }
	    $htmlname[$iparent][$dircnt++] = $filecurr;
	    $dirtot[$iparent] = $dircnt;
	  }
	}
	print OFIL "<br><br>\n";
	for ($kval=$jval; $kval <= $jpgmax; $kval++) {
	#  $kfile = $jpgsort[$kval];
	#foreach $kval (keys %filesort) {
	#  $kfile = $filesort{$kval};
	  $kfile = $jpgsort[$kval];
	  my $kthumb = $thumbsort[$kval];
	  if ($ival == 0 && $jval > 29) {
	    $kthumb = "\.$kthumb";
	  }
#	  $kthumb = $kstr . "\\" . substr($kthumb,$dirs0length+1,length($kthumb));
	  $ktext = $txtsort[$kval];
	  if ($kfile =~ /\.(jpg|jpeg|jpe|gif|png|bmp)/i) {
	    $line = "<a href=\"\#A$kval\"><img src=\"$kthumb\" height=\"40\%\" TEXT=\"$ktext\"><\/a>\n";
	    $line =~ tr$\\$/$;
	    print OFIL $line;
	  }
	  elsif ($kfile =~ /\.(avi|mpg|wmv|mpeg|mp4|rm|mov|asf)/i) {
	    $line = "<br><br>";
	    if ($filecurr eq 'main') {
	      $line = $line . "<a href=\"$kfile\"><img src=\".\\htm4pics\\movie3.gif\"><\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	    else {
	      $line = $line . "<a href=\"$kfile\"><img src=\".\\movie3.gif\"><\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	    if ($txtsort[$kval] ne '' ) {
	      $filenamep = '<' . $txtsort[$kval];
	      open(INFIL, $filenamep);
	      while (<INFIL>) {
		print OFIL "<br>$_";
	      }
	      print OFIL "<br>\n";
	      close(INFIL);
	    }
	    $videoseen = 1;
	  }
	  # au|ram|ra|wav|mp3
	  else {
	    if ($filecurr eq 'main' && $jval < 30 ) {
	      $line = "<br><br><a href=\"$kfile\"><img src=\".\\htm4pics\\audio3.gif\"><\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	    else {
	      $line = "<br><br><a href=\"$kfile\"><img src=\".\\audio3.gif\"><\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	    if ($txtsort[$kval] ne '' ) {
	      $filenamep = '<' . $txtsort[$kval];
	      open(INFIL, $filenamep);
	      while (<INFIL>) {
		print OFIL "<br>$_";
	      }
	      print OFIL "<br>\n";
	      close(INFIL);
	    }
	    $audioseen = 1;
	  }
	}
	print OFIL "<br>\n";
	if ($jpgmax < ($jpgcnt-1)) {
	  $filen = ($jval / 30) + 1;
	  $maxfilen = ($jpgcnt / 30);
	  if ($jpgcnt % 30) {
	    $maxfilen = (($jpgcnt - ($jpgcnt % 30)) / 30) + 1;
	  }
	  $maxfilen = length($maxfilen);
	  $filen = '0000' . $filen;
	  $filen = substr($filen, -$maxfilen, 5);
	  $file = $dirs[$ival];
	  if ($file =~ /\\([^\\]+)$/ ) {
	    $filenamep = $1;
	    $line = "<br><a href=\"\.\\$filecurra\_$filen.html\">Next<\/a>\n";
	    $line =~ tr$\\$/$;
	    print OFIL $line;
	  }
	  if ($ival == 0 && $maxpages > 1) {
	    my $dir = '.';
	    my $filen = $pagenumber;
	    if ($jval == 0) {
	      $dir = '.\htm4pics';
	      $filen = 1;
	    }
	    $line = "<br><a href=\"$dir\\main\_$filen.html\">Next<\/a>\n";
	    print OFIL $line;
	  }
	}
	if (( ! ($filecurr eq 'main') ) || ($jval >0 )) {
	  $line = "<br><a href=\"..\\main.html\">Home<\/a>\n";
	  $line =~ tr$\\$/$;
	  print OFIL $line;
	}
	print OFIL "<br><br><br><br>\n";
			
	for ($kval=$jval; $kval <= $jpgmax; $kval++) {
	  $kfile = $jpgsort[$kval];
#	  $kfile = $kstr . "\\" . substr($kfile,$dirs0length+1,length($kfile));
	  $tnfile = $kfile;
	  if ($kfile =~ /\.(jpg|jpeg|jpe|gif|png|bmp)/i) {
	    if ( $txtsort[$kval] ne '' ) {
	      print OFIL "<br>\n";  # force images with text comments to appear by themselves
	    }
	    if ($tnfile =~ /(.*)tn\_(.*)/) {
	      $tnfile = $1 . $2;
	    }
	    $line = "<a NAME=\"A$kval\" href=\"$tnfile\"><img src=\"$kfile\" height=\"95\%\"><\/a>\n"; #<a href=\"\#TOP\"\/>Top<\/a>\n";
	    $line =~ tr$\\$/$;
	    print OFIL $line;
	    if ( $txtsort[$kval] ne '' ) {
	      $filenamep = '<' . $txtsort[$kval];
	      open(INFIL, $filenamep);
	      while (<INFIL>) {
		print OFIL "<br>$_";
	      }
	      print OFIL "<br>\n";
	      close(INFIL);
	    }
	  }
	  elsif ($kfile =~ /\.(avi|mpg|wmv|mpeg|mp4|rm|mov|asf)/i) {
	    $line = "<br><br>";
	    if ($filecurr eq 'main') {
	      $line = $line . "<a href=\"$kfile\"><img src=\".\\htm4pics\\movie3.gif\"><\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	    else {
	      $line = $line . "<a href=\"$kfile\"><img src=\".\\movie3.gif\"><\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	    if ($txtsort[$kval] ne '' ) {
	      $filenamep = '<' . $txtsort[$kval];
	      open(INFIL, $filenamep);
	      while (<INFIL>) {
		print OFIL "<br>$_";
	      }
	      print OFIL "<br>\n";
	      close(INFIL);
	    }
	    $videoseen = 1;
	  }
	  # au|ram|ra|wav|mp3
	  else {
	    if ($filecurr eq 'main' && $jval < 30 ) {
	      $line = "<br><br><a href=\"$kfile\"><img src=\".\\htm4pics\\audio3.gif\"><\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	    else {
	      $line = "<br><br><a href=\"$kfile\"><img src=\".\\audio3.gif\"><\/a>\n";
	      $line =~ tr$\\$/$;
	      print OFIL $line;
	    }
	    if ($txtsort[$kval] ne '' ) {
	      $filenamep = '<' . $txtsort[$kval];
	      open(INFIL, $filenamep);
	      while (<INFIL>) {
		print OFIL "<br>$_";
	      }
	      print OFIL "<br>\n";
	      close(INFIL);
	    }
	    $audioseen = 1;
	  }
	}
      }
    }
    if ($ival == 0 && $maxpages > 1) {
      my $dir = '.';
      if ($jval == 0) {
	$dir = '.\htm4pics';
      }
      my $filen = $pagenumber + 1;
      $line = "<br><br><a href=\"$dir\\main\_$filen.html\">Next<\/a>\n";
    }

  if (( ! ($filecurr eq 'main') ) || $jval > 0) {
    print OFIL "<br><br><a href=\"../main.html\">Home</a>\n";
  }
  print OFIL "<br><br><br><h7>Generated with htm4pics (www.jiveysoft.com)</h7><\/body><\/html>\n";
  close OFIL
}

if ($videoseen) {
  $program = $0;
  $path = "";
  if ($program =~ /(.*\\)[^\\]+/) {
    $path = $1;
  }
  copy( $path . 'movie3.gif', "$dirs[0]htm4pics\\movie3.gif");
}
if ($audioseen) {
  $program = $0;
  if ($program =~ /(.*\\)[^\\]+/) {
    $path = $1;
  }
  copy( $path . 'audio3.gif', "$dirs[0]htm4pics\\audio3.gif");
}

# move auto start files

copy( 'ShowPics.exe', "$dirs[0]ShowPics.exe");
copy( 'autorun.inf', "$dirs[0]autorun.inf");

$ifile = $ifile - 1;
print "Processed ".($ifile+1)." directories\n";
print "\n\nEnter RETURN to exit: ";
<STDIN>;
0;


# The following function checks whether there is anything to be used in a
# subdirectory or any of its descendents.

sub checkdirs {
  my ($file) = @_;

  my $jpgcnt1 = 0;
  my $ndirs = 0;
  my @dirs;

  opendir(CURRDIR, $file) || die("couldn't open $file.");
  while (my $filename = readdir(CURRDIR)) {
    my $filename1 = $file . '\\' . $filename;
    if (! ($filename =~ /'[Tt][Nn]\_.*/) ) {
      if ( $filename =~ /\.(jpg|gif|png|avi|mpg|wmv|mpeg|mp4|jpeg|rm|mov|au|ram|ra|asf|wav|mp3)/i ) {
        ++$jpgcnt1;
      }
    }
    if (-d $filename1) {
      if (($filename ne '.') && ($filename ne '..') && ($filename ne 'htm4pics')) {
        $dirs[$ndirs++] = $filename1;
      }
    }
  }
  closedir(CURRDIR);
  if ( $jpgcnt1 == 0 ) {
    for (my $i=0; $i<$ndirs; $i++) {    # handle any subdirs
      if ( checkdirs($dirs[$i]) == 0 ) {   #remove subdirs that aren't used
        for (my $j=$i+1; $j<$ndirs; $j++) {
          $dirs[$j-1] = $dirs[$j];
        }
        $i--;
        $ndirs--;
      }
    }
  }
  if ( ($jpgcnt1 + $ndirs) > 0 ) {
    return( 1 );
  }
  else {
    return( 0 );
  }
}



# revision history

# 1.09 021011 make images with comments appear by themselves so the comments are directly under them

# 1.08 020827 corrected problem with moving exe and inf files

# 1.07 020805 added strict namespacing
#             added checkdirs to insure only pages with visible contents are generated
#      020806 added number of images in directory to accompany URL
#      020807 added indication of source directory in title of browser (offset by the base directory)

# 1.06 020712 corrected a problem with a bad variable name.

# 1.05 020610 modified to sort directories without regard for the case of characters used in the name
#             modified to move files for auto starting into the directory

# 1.04 020410 added support for thumbnails in the same directory as originals, if thumbnails are identified by prefix of tn_ (this is for very large images when a page with a number of them may not load rapidly or even have enough space on some machines, the thumbnails are used as the small and large images displayed on the current page.  Clicking on the large image will result in the original being opened).
 
# 1.03 011221 changed directory markers from \ to / so it images will display correctly on linux

# 1.02 011211 modified so that the same name can be used for a subdirectory under two or more different directories

# 1.01 011208 modified name of directory for storage of html files from "htmls" to "htm4pics" and delete any files in that directory before creating new files to eliminate leaving files for directories not now present, etc.

# 1.00a 011115 added code to move the movie1.gif from the home file if it is needed.
