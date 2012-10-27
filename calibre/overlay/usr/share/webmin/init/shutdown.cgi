#!/usr/bin/perl
# shutdown.cgi
# Shutdown the system immediately..

require './init-lib.pl';
&ReadParse();
$access{'shutdown'} || &error($text{'shutdown_ecannot'});
&ui_print_header(undef, $text{'shutdown_title'}, "");
print "<p>\n";
$ttcmd = "<tt>$config{'shutdown_command'}</tt>";
if ($in{'confirm'}) {
	print "<font size=+1>",&text('shutdown_exec', $ttcmd),"</font><p>\n";
	&shutdown_system();
	&webmin_log("shutdown");
	}
else {
	print "<font size=+1>",&text('shutdown_rusure', $ttcmd),"</font>\n";
	print "<center><form action=shutdown.cgi>\n";
	print "<input type=submit value=\"$text{'shutdown_ok'}\" ",
	      "name=confirm>\n";
	print "</form></center>\n";
	}
&ui_print_footer("", $text{'index_return'});

