#!/usr/bin/perl
# close.cgi
# Remove some class from the open list

require './software-lib.pl';
&ReadParse();
@heiropen = &get_heiropen();
@heiropen = grep { $_ ne $in{'what'} } @heiropen;
&save_heiropen(\@heiropen);
&redirect("tree.cgi#$in{'what'}");

