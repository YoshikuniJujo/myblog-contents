#!/usr/local/bin/perl

open LOG, ">>log";
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time+9*60*60);
$year = $year + 1900;
$mon  = $mon + 1;
@env_keys = keys(ENV);
$addr = $ENV{'REMOTE_ADDR'};
$host = $ENV{'REMOTE_HOST'} or gethostbyaddr(pack('C4',split(/\./,"216.239.37.100")),2);
if ($min <= 9) {
  print LOG "$year/$mon/$mday $hour:0$min";
} else {
  print LOG "$year/$mon/$mday $hour:$min";
}
print LOG " ";
print LOG "$ENV{'REMOTE_ADDR'}";
print LOG " ";
#print LOG $host;
print LOG "$ENV{'HTTP_USER_AGENT'} ";
print LOG "$ENV{'HTTP_VIA'} ";
print LOG "$ENV{'HTTP_FORWARDED'} ";
print LOG "$ENV{'HTTP_X_FORWARDED_FOR'} ";
print LOG "\n";
# print LOG "@env_keys\n";
close LOG;

open FLAG, "flag";
$flag = <FLAG>;
open FLAG, ">flag";

if ($flag) {
  print FLAG "0";
  print "Content-type: image/jpg\n\n";
  open IMAGE, "../images/powered-by-gentoo2.jpg"
} else {
  print FLAG "1";
  print "Content-type: image/png\n\n";
  open IMAGE, "../images/ralph_gentoo_badge.png";
}

while (<IMAGE>) {
  print
}

close FLAG
