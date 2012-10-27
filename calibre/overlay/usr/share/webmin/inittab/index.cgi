#!/usr/bin/perl
# index.cgi
# Display a list of run-levels and the actions that are run at boot and
# shutdown time for each level

require './inittab-lib.pl';
&ui_print_header(undef, $module_info{'desc'}, "", "index", 1, 1, 0,
	&help_search_link("inittab", "man"));

print &ui_form_start("delete.cgi", "post");
@links = ( &select_all_link("d"),
	   &select_invert_link("d"),
	   "<a href=edit_inittab.cgi?new=1>$text{'inittab_new'}</a>" );
print &ui_links_row(\@links);
@tds = ( "width=5" );
print &ui_columns_start([ "",
			  &hlink( $text{ 'inittab_id' }, "id" ),
			  &hlink( $text{ 'inittab_active' }, "active" ),
			  &hlink( $text{ 'inittab_runlevels' }, "runlevels" ),
			  &hlink( $text{ 'inittab_action' }, "action" ),
			  &hlink( $text{ 'inittab_process' }, "process" ) ],
			100, 0, \@tds);
foreach $i (&parse_inittab()) {
	local @cols;
	push(@cols, "<a href='edit_inittab.cgi?id=$i->{'id'}'>".
		    &html_escape($i->{'id'})."</a>");
	push(@cols, $i->{'comment'} ? "<font color=#ff0000>$text{'no'}</font>"
				    : $text{'yes'});
	local @rls = @{$i->{'levels'}};
	push(@cols, @rls ? &html_escape(join(", ", @rls))
			 : $text{'inittab_none'});
	push(@cols, $text{"inittab_".$i->{'action'}} ||
		    "<tt>".&html_escape($i->{'action'})."</tt>");
	push(@cols, &html_escape($i->{'process'}));
	print &ui_checked_columns_row(\@cols, \@tds, "d", $i->{'id'});
	}
print &ui_columns_end();
print &ui_links_row(\@links);
print &ui_form_end([ [ "delete", $text{'index_delete'} ] ]);

print &ui_hr();
print "<table width=100%><tr>\n";
print "<form action=apply.cgi>\n";
print "<td><input type=submit value='$text{'inittab_apply'}'></td>\n";
print "<td>$text{'inittab_applymsg'}</td>\n";
print "</form></tr></table><br>\n";

&ui_print_footer( "/", $text{'index'} );

