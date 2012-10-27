#!/usr/bin/perl
# Display a list of other webmin servers

use strict;
use warnings;
require './servers-lib.pl';
our (%text, %config, %access);
&ui_print_header(undef, $text{'index_title'}, "", undef, 1, 1);

my @servers = &list_servers_sorted(1);

# Work out links
my @linksrow;
if ($access{'edit'}) {
	if (@servers) {
		print &ui_form_start("delete_servs.cgi");
		push(@linksrow, &select_all_link("d"),
				&select_invert_link("d"));
		}
	if ($access{'add'}) {
		push(@linksrow, "<a href='edit_serv.cgi?new=1'>".
				"$text{'index_add'}</a>");
		}
	}

if (@servers && $config{'display_mode'}) {
	# Show table of servers
	print &ui_links_row(\@linksrow);
	print &ui_columns_start([
		$access{'edit'} ? ( "" ) : ( ),
		$text{'index_host'},
		$text{'index_desc'},
		$text{'index_group'},
		$text{'index_os'} ], 100);
	foreach my $s (@servers) {
		my @cols;
		my $table =
			"<table cellpadding=0 cellspacing=0 width=100%><tr>\n";
		if (!$access{'links'} || !$s->{'port'}) {
			$table .= "<td>\n";
			$table .= ($s->{'realhost'} || $s->{'host'});
			$table .= ":$s->{'port'}" if ($s->{'port'});
			$table .= "</td>\n";
			}
		else {
			if ($s->{'user'} || $s->{'autouser'}) {
				$table .= "<td><a href='link.cgi/$s->{'id'}/' target=_top>\n";
				}
			else {
				$table .= "<td><a href=".&make_url($s)." target=_top>\n";
				}
			$table .= ($s->{'realhost'} || $s->{'host'});
			$table .= ":$s->{'port'}</a></td>\n";
			}
		$table .= "<td align=right>";
		if ($s->{'autouser'} && &logged_in($s)) {
			$table .= "<a href='logout.cgi?id=$s->{'id'}'>($text{'index_logout'})</a>\n";
			}
		if ($access{'edit'}) {
			$table .= "<a href='edit_serv.cgi?id=$s->{'id'}'>($text{'index_edit'})</a>\n";
			}
		$table .= "</td> </tr></table>\n";
		push(@cols, $table);
		push(@cols, $s->{'desc'});
		push(@cols, $s->{'group'} || $text{'index_none'});
		my ($type) = grep { $_->[0] eq $s->{'type'} }
				  &get_server_types();
		push(@cols, $type->[1]);
		if ($access{'edit'}) {
			print &ui_checked_columns_row(\@cols, undef,
						      "d", $s->{'id'});
			}
		else {
			print &ui_columns_row(\@cols);
			}
		}
	print &ui_columns_end();
	}
elsif (@servers) {
	# Show server icons
	print &ui_links_row(\@linksrow);
	my (@afters, @befores);
	if ($access{'edit'}) {
		my $sep = length($text{'index_edit'}) > 10 ? "<br>" : " ";
		@afters = map { $sep."<a href='edit_serv.cgi?id=$_->{'id'}'>(".$text{'index_edit'}.")</a>" } @servers;
		@befores = map { &ui_checkbox("d", $_->{'id'}) } @servers;
		}
	my @titles = map { &make_iconname($_) } @servers;
	my @icons = map { "images/$_->{'type'}.gif" } @servers;
	my @links = map { !$access{'links'} ? undef :
		       $_->{'user'} || $_->{'autouser'} ?
			"link.cgi/$_->{'id'}/" : &make_url($_) } @servers;
	&icons_table(\@links, \@titles, \@icons, undef, "target=_top",
		     undef, undef, \@befores, \@afters);
	}
else {
	print "<b>$text{'index_noservers'}</b> <p>\n";
	}
if ($access{'edit'}) {
	print &ui_links_row(\@linksrow);
	if (@servers) {
		print &ui_form_end([ [ "delete", $text{'index_delete'} ] ]);
		}
	}

my $myip = &get_my_address();
my $myscan = &address_to_broadcast($myip, 1) if ($myip);
if ($access{'find'} || $access{'auto'}) {
	print &ui_hr();
	print &ui_buttons_start();
	if ($access{'find'}) {
		# Buttons to scan and broadcast for servers
		my %miniserv;
		&get_miniserv_config(\%miniserv);
		my $port = $config{'listen'} || $miniserv{'listen'} || 10000;
		print &ui_buttons_row("find.cgi", $text{'index_broad'},
						  $text{'index_findmsg'});
		print &ui_buttons_row("find.cgi", $text{'index_scan'},
		      &text('index_scanmsg', &ui_textbox("scan", $myscan, 15)).
		      "<br><table>\n".
		      "<tr> <td><b>$text{'index_defuser'}</b></td>\n".
		      "<td>".&ui_textbox("defuser", undef, 20)."</td> </tr>".
		      "<tr> <td><b>$text{'index_defpass'}</b></td>\n".
		      "<td>".&ui_password("defpass", undef, 20)."</td> </tr>".
		      "<tr> <td><b>$text{'index_defport'}</b></td>\n".
		      "<td>".&ui_textbox("port", $port, 20)."</td> </tr>".
		      "</table>\n"
		      );
		}
	if ($access{'auto'}) {
		# Button for auto-discovery form
		print &ui_buttons_row("edit_auto.cgi", $text{'index_auto'},
						  $text{'index_automsg'});
		}
	print &ui_buttons_end();
	}

&ui_print_footer("/", $text{'index'});

sub make_url
{
return sprintf "http%s://%s:%d/",
	$_[0]->{'ssl'} ? 's' : '', $_[0]->{'host'}, $_[0]->{'port'};
}

sub make_iconname
{
my $rv;
if ($_[0]->{'desc'} && !$config{'show_ip'}) {
	$rv = $_[0]->{'desc'};
	}
elsif ($_[0]->{'realhost'}) {
	$rv = "$_[0]->{'realhost'}:$_[0]->{'port'}";
	}
else {
	$rv = "$_[0]->{'host'}:$_[0]->{'port'}";
	}
if (&logged_in($_[0])) {
	$rv .= "</a> <a href='logout.cgi?id=$_->{'id'}'>(".$text{'index_logout'}.")";
	}
return $rv;
}

