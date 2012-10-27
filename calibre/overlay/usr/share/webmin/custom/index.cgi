#!/usr/bin/perl
# index.cgi
# Display commands available for execution

require './custom-lib.pl';
&ui_print_header(undef, $text{'index_title'}, "", "intro", 1, 1);

@cust = grep { &can_run_command($_) } &list_commands();
@cust = &sort_commands(@cust);

# Build links
@links = ( );
if ($access{'edit'}) {
	push(@links,"<a href='edit_cmd.cgi?new=1'>$text{'index_create'}</a>");
	push(@links,"<a href='edit_file.cgi?new=1'>$text{'index_ecreate'}</a>");
	push(@links,"<a href='edit_sql.cgi?new=1'>$text{'index_screate'}</a>");
	}

if (!@cust) {
	print "<b>$text{'index_none'}</b> <p>\n";
	}
elsif ($config{'display_mode'} == 0) {
	# Show command buttons
	print &ui_links_row(\@links);
	@grid = ( );
	$form = 0;
	for($i=0; $i<@cust; $i++) {
		$c = $cust[$i];
		@a = @{$c->{'args'}};
		local $html;
		if ($c->{'edit'}) {
			$html .= &ui_form_start("view.cgi");
			}
		elsif ($c->{'sql'}) {
			$html .= &ui_form_start("sql.cgi");
			}
		else {
			local @up = grep { $_->{'type'} == 10 } @a;
			if (@up) {
				# Has upload fields
				@ufn = map { $_->{'name'} } @up;
				$upid = time().$$;
				$html .= &ui_form_start("run.cgi?id=$upid",
				  "form-data", undef,
				  &read_parse_mime_javascript($upid, \@ufn));
				}
			elsif (@a) {
				$html .= &ui_form_start("run.cgi", "post");
				}
			else {
				$html .= &ui_form_start("run.cgi");
				}
			}
		$html .= &ui_hidden("id", $c->{'id'});
		$w = $config{'columns'} == 2 ? 2 : 4;
		$html .= &ui_table_start(undef, undef, $w,
		   $config{'columns'} == 1 ? [ "width=20%", "width=30%" ]
					   : [ "width=30%" ]);
		($got_submit) = grep { $_->{'type'} == 16 } @a;
		if (!$got_submit) {
			$html .= &ui_table_row(undef,
					&ui_submit($c->{'desc'}), $w, []);
			}
		if ($c->{'html'}) {
			$html .= &ui_table_row(undef,
				&filter_javascript($c->{'html'}), $w, []);
			}
		foreach $a (@a) {
			$html .= &ui_table_row(&html_escape($a->{'desc'}),
					&show_parameter_input($a, $formno));
			}
		if (scalar(@a)%2 && $w == 4) {
			# Hack to make spacing nicer
			$html .= &ui_table_row(" ", " ");
			}
		if ($access{'edit'}) {
			if ($c->{'edit'}) {
				$link = "<a href='edit_file.cgi?id=$c->{'id'}'>$text{'index_fedit'}</a>";
				}
			elsif ($c->{'sql'}) {
				$link = "<a href='edit_sql.cgi?id=$c->{'id'}'>$text{'index_sedit'}</a>";
				}
			else {
				$link = "<a href='edit_cmd.cgi?id=$c->{'id'}'>$text{'index_edit'}</a>";
				}
			$html .= &ui_table_row(undef,
					&ui_links_row([ $link ]), $w);
			}
		$html .= &ui_table_end();
		$html .= &ui_form_end();
		push(@grid, $html);
		$form++;
		}
	print &ui_grid_table(\@grid, $config{'columns'} || 1, 100,
	     $config{'columns'} == 2 ? [ "width=50%", "width=50%" ] : [ ]);
	}
else {
	# Just show table of commands
	print &ui_links_row(\@links);
	@tds = ( "width=30%", "width=60%", "width=10% nowrap" );
	print &ui_columns_start([
		$text{'index_cmd'},
		$text{'index_desc'},
		$text{'index_acts'},
		], 100, 0, \@tds);
	foreach $c (@cust) {
		@cols = ( );
		local @links = ( );
		if ($access{'edit'}) {
			local $e = $c->{'edit'} ? "edit_file.cgi" :
				   $c->{'sql'} ? "edit_sql.cgi" :
						 "edit_cmd.cgi";
			push(@links, "<a href='$e?id=$c->{'id'}'>".
				     "$text{'index_ed'}</a>");
			}
		if ($c->{'edit'} && !@{$c->{'args'}}) {
			# Open file editor directly, as file is known
			push(@cols, "<a href='view.cgi?id=$c->{'id'}'>".
				    &html_escape($c->{'desc'})."</a>");
			push(@links, "<a href='view.cgi?id=$c->{'id'}'>".
				     $text{'index_acted'}."</a>");
			}
		elsif ($c->{'sql'} && !@{$c->{'args'}}) {
			# Execute SQL directorly, as no args
			push(@cols, "<a href='sql.cgi?id=$c->{'id'}'>".
			      	    &html_escape($c->{'desc'})."</a>");
			push(@links, "<a href='sql.cgi?id=$c->{'id'}'>".
				     $text{'index_actrun'}."</a>");
			}
		elsif ($c->{'sql'}) {
			# Link to SQL query form
			push(@cols, "<a href='sqlform.cgi?id=$c->{'id'}'>".
			      	    &html_escape($c->{'desc'})."</a>");
			push(@links, "<a href='sqlform.cgi?id=$c->{'id'}'>".
				     $text{'index_actsql'}."</a>");
			}
		elsif (!@{$c->{'args'}}) {
			# Link direct to execute page
			push(@cols, "<a href='run.cgi?id=$c->{'id'}'>".
			      	    &html_escape($c->{'desc'})."</a>");
			push(@links, "<a href='run.cgi?id=$c->{'id'}'>".
				     $text{'index_actrun'}."</a>");
			}
		else {
			# Link to parameters form
			push(@cols, "<a href='form.cgi?id=$c->{'id'}'>".
			      	    &html_escape($c->{'desc'})."</a>");
			push(@links, "<a href='form.cgi?id=$c->{'id'}'>".
				     $text{'index_actform'}."</a>");
			}
		push(@cols, $c->{'html'});
		push(@cols, &ui_links_row(\@links));
		print &ui_columns_row(\@cols, \@tds);
		}
	print &ui_columns_end();
	}
print &ui_links_row(\@links);

&ui_print_footer("/", $text{'index'});

