#!/usr/bin/perl
# delete_user.cgi
# Delete a webmin user

require './acl-lib.pl';
&ReadParse();
&error_setup($text{'delete_err'});
$access{'delete'} || &error($text{'delete_ecannot'});
&can_edit_user($in{'user'}) || &error($text{'delete_euser'});
if ($base_remote_user eq $in{'user'}) {
	&error($text{'delete_eself'});
	}
&delete_user($in{'user'});
&delete_from_groups($in{'user'});
&reload_miniserv();
&webmin_log("delete", "user", $in{'user'});
&redirect("");

