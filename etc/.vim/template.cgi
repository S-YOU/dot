#!/usr/bin/perl

print "Content-Type: text/html\n\n";

use strict;
use warnings;

use CGI;
use CGI::Carp qw(fatalsToBrowser);

our $q = new CGI;

foreach my $name ($q->param()) {
	print $name, "\t", $q->param($name), "\n";
}
