#!/usr/bin/perl
# change_theme.cgi
# Change the current webmin theme

require './webmin-lib.pl';
&ReadParse();

&lock_file("$config_directory/config");
($gtheme, @others) = split(/\s+/, $gconfig{'theme'});
if ($in{'theme'}) {
	$gconfig{'theme'} = join(" ", $in{'theme'}, @others);
	}
else {
	delete($gconfig{'theme'});
	}
&write_file("$config_directory/config", \%gconfig);
&unlock_file("$config_directory/config");

&lock_file($ENV{'MINISERV_CONFIG'});
&get_miniserv_config(\%miniserv);
if ($in{'theme'}) {
	$miniserv{'preroot'} = join(" ", $in{'theme'}, @others);
	}
else {
	delete($miniserv{'preroot'});
	}
&put_miniserv_config(\%miniserv);
&unlock_file($ENV{'MINISERV_CONFIG'});
&reload_miniserv();

&webmin_log('theme', undef, undef, \%in);
&ui_print_header(undef, $text{'themes_title'}, "");
print "$text{'themes_ok'}<p>\n";
print &js_redirect("/", "top");
&ui_print_footer("", $text{'index_return'});

