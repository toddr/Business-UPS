#!/usr/local/bin/perl

use lib '.';
use Business::UPS;


# Try a US shipment
#
my ($shipping,$ups_zone,$error) = getUPS(qw/GNDCOM 23606 11111 50/);
$error and die "ERROR: $error\n";
print "UPS Version " . $Business::UPS::VERSION . "\n";
print "From: 23606 to 11111 Weight 50 GNDCOM\n";
print "Shipping is \$$shipping\n";
print "UPS Zone is $ups_zone\n";
exit(0);

# How about a shipment from the US to Great Britain
#
my ($type,$from,$to,$wgt,$co) = qw/XPR 23606 B67JH 10 GB/;
my ($shipping,$ups_zone,$error) = getUPS($type,$from,$to,$wgt,$co,'', '', '', '', '');
print "Tying:\n";
print "From: $from\nTo:$to\nWeight: $wgt\nCountry:	$co\n";
$error and die "ERROR: $error\n";
print "Shipping is \$$shipping\n";
print "UPS Zone is $ups_zone\n";

# Track a package with a bad tracking number (Will produce error) 
#
%t = UPStrack("q211");
if (! $t{error}) {
	foreach $key (keys %t) {
		print "KEY: $key = $t{$key}\n";
	}
}
else {
	print "ERROR: $t{error}\n";
}

# A good tracking number
#
print "\n\n";
%t = UPStrack("1ZX29W290250802756");

foreach (keys %t) {
	next if /^Scanning/;
	print "$_ = $t{$_}\n";
}
foreach (split "\n",$t{Scanning}) {
	print "SCANNED: $_\n\n";
}
