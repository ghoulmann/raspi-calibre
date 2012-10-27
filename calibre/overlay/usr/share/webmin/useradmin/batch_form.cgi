#!/usr/bin/perl
# batch_form.cgi
# Display a form for doing batch creation, updates or deletion from a text file

require './user-lib.pl';
$access{'batch'} || &error($text{'batch_ecannot'});
&ui_print_header(undef, $text{'batch_title'}, "");

# Instructions
print &ui_hidden_start($text{'batch_instr'}, "instr", 0, "batch_form.cgi");
print "$text{'batch_desc'}\n";
$pft = &passfiles_type();
print "<p><tt>",$text{'batch_desc'.$pft},"</tt><p>\n";
print "$text{'batch_descafter'}<br>\n";
print "$text{'batch_descafter2'}\n";
print &ui_hidden_end("instr");

print &ui_form_start("batch_exec.cgi", "form-data");
print &ui_table_start($text{'batch_header'}, undef, 2);

# Source file
print &ui_table_row($text{'batch_source'},
	&ui_radio_table("source", 0,
	  [ [ 0, $text{'batch_source0'}, &ui_upload("file") ],
	    [ 1, $text{'batch_source1'}, &ui_textbox("local", undef, 40)." ".
					 &file_chooser_button("local") ],
	    [ 2, $text{'batch_source2'}, &ui_textarea("text", undef, 5, 60) ]
	  ]));

if ($access{'cothers'} == 1 || $access{'mothers'} == 1 ||
    $access{'dothers'} == 1) {
	# Do other modules?
	print &ui_table_row($text{'batch_others'},
		&ui_yesno_radio("others", int($config{'default_other'})));
	}

# Only run post-command at end?
print &ui_table_row($text{'batch_batch'},
	&ui_yesno_radio("batch", 0));

if ($access{'makehome'}) {
	# Create home dir
	print &ui_table_row($text{'batch_makehome'},
		&ui_yesno_radio("makehome", 1));
	}

if ($access{'copy'} && $config{'user_files'} =~ /\S/) {
	# Copy files to homes
	print &ui_table_row($text{'batch_copy'},
		&ui_yesno_radio("copy", 1));
	}

if ($access{'movehome'}) {
	# Move home dirs
	print &ui_table_row($text{'batch_movehome'},
		&ui_yesno_radio("movehome", 1));
	}

if ($access{'chuid'}) {
	# Update UIDs on files
	print &ui_table_row($text{'batch_chuid'},
		&ui_radio("chuid", 1, [ [ 0, $text{'no'} ],
					[ 1, $text{'home'} ],
					[ 2, $text{'uedit_allfiles'} ] ]));
	}

if ($access{'chgid'}) {
	# Update GIDs on files
	print &ui_table_row($text{'batch_chgid'},
		&ui_radio("chgid", 1, [ [ 0, $text{'no'} ],
					[ 1, $text{'home'} ],
					[ 2, $text{'uedit_allfiles'} ] ]));
	}

# Delete home dirs
print &ui_table_row($text{'batch_delhome'},
	&ui_yesno_radio("delhome", 1));

# Encrypt password
print &ui_table_row($text{'batch_crypt'},
	&ui_yesno_radio("crypt", 0));

print &ui_table_end();
print &ui_form_end([ [ undef, $text{'batch_upload'} ] ]);

&ui_print_footer("", $text{'index_return'});

