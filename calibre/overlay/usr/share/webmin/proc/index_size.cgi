#!/usr/bin/perl
# index_cpu.cgi

require './proc-lib.pl';
&ui_print_header(undef, $text{'index_title'}, "", "size", !$no_module_config, 1);

&index_links("size");
if (defined(&get_memory_info)) {
	@m = &get_memory_info();
	if (@m) {
		print &text('index_mem2', &nice_size($m[0]*1024),
			    &nice_size($m[1]*1024)),"\n";
		print "&nbsp;&nbsp;",
			&text('index_swap2', &nice_size($m[2]*1024),
					     &nice_size($m[3]*1024)),"<p>\n";
		}
	}
print &ui_columns_start([
	$text{'pid'},
	$text{'owner'},
	$text{'size'},
	$text{'command'}
	], 100);

@procs = sort { $b->{'size'} <=> $a->{'size'} } &list_processes();
@procs = grep { &can_view_process($_->{'user'}) } @procs;
foreach $pr (@procs) {
	$p = $pr->{'pid'};
	local @cols;
	if (&can_edit_process($pr->{'user'})) {
		push(@cols, "<a href=\"edit_proc.cgi?$p\">$p</a>");
		}
	else {
		push(@cols, $p);
		}
	push(@cols, $pr->{'user'});
	push(@cols, $pr->{'size'});
	push(@cols, &html_escape(&cut_string($pr->{'args'})));
	print &ui_columns_row(\@cols);
	}
print &ui_columns_end();

&ui_print_footer("/", $text{'index'});

