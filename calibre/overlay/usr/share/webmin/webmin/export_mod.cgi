#!/usr/bin/perl
# Create and output a wbm.gz file of selected modules

require './webmin-lib.pl';
&ReadParse();
&error_setup($text{'export_err'});
@mods = split(/\0/, $in{'mod'});
@mods || &error($text{'delete_enone'});

# Make sure we have the needed commands
&has_command("tar") || &error(&text('export_ecmd', "<tt>tar</tt>"));
&has_command("gzip") || &error(&text('export_ecmd', "<tt>gzip</tt>"));
$in{'to'} == 0 || $in{'file'} =~ /^\// || &error($text{'export_efile'});

# Make the tar.gz file
$temp = $in{'to'} ? $in{'file'} : &transname();
chdir(&module_root_directory($mods[0])."/..");
$cmd = "tar chf -";
foreach $m (@mods) {
	$cmd .= " $m";
	}
$cmd .= " | gzip -c >".quotemeta($temp);
$out = &backquote_logged("($cmd) 2>&1 </dev/null");
$? && &error("<pre>$out</pre>");

if ($in{'to'} == 0) {
	# Output the file
	print "Content-type: application/octet-stream\n\n";
	open(TEMP, $temp);
	while(<TEMP>) {
		print $_;
		}
	close(TEMP);
	unlink($temp);
	}
else {
	# Tell the user
	&ui_print_header(undef, $text{'export_title'}, "");

	print &text('export_done', "<tt>$in{'file'}</tt>"),"<p>\n";

	&ui_print_footer("/$module_name/edit_mods.cgi", $text{'mods_return'},
			 "", $text{'index_return'});
	}


