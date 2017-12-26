#!/usr/bin/perl
#取月份
#Usage: month.pl [+/-月份偏移量]
    
use Time::Local;

if ($#ARGV < 0) {
    $offset = 0;
} else {
    $offset = $ARGV[0];
}


$dest_time = time();
for ($i = 0; $i < abs($offset); $i++) {
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($dest_time);
    if ($offset < 0) {
        $dest_time = timelocal($sec,$min,$hour,01,$mon,$year) - 24*60*60;
    } else {
        $dest_time = timelocal($sec,$min,$hour,01,$mon,$year) + 31*24*60*60;
    }
}

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($dest_time);

$year += 1900;
$mon = (qw(01 02 03 04 05 06 07 08 09 10 11 12))[$mon];;
print $year.$mon."\n";

