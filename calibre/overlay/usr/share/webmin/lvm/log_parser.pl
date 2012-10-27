# log_parser.pl
# Functions for parsing this module's logs

do 'lvm-lib.pl';

# parse_webmin_log(user, script, action, type, object, &params)
# Converts logged information from this module into human-readable form
sub parse_webmin_log
{
local ($user, $script, $action, $type, $object, $p) = @_;
if ($action eq 'mkfs') {
	return &text('log_mkfs_lv', "<tt>".&html_escape($p->{'fs'})."</tt>",
		     "<tt>".&html_escape($object)."</tt>");
	}
else {
	return &text("log_${action}_${type}",
		     "<tt>".&html_escape($object)."</tt>",
		     "<tt>".&html_escape($p->{'vg'})."</tt>");
	}
}

