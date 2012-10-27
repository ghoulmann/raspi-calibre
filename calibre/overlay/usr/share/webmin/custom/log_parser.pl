# log_parser.pl
# Functions for parsing this module's logs

do 'custom-lib.pl';

# parse_webmin_log(user, script, action, type, object, &params)
# Converts logged information from this module into human-readable form
sub parse_webmin_log
{
local ($user, $script, $action, $type, $object, $p) = @_;
if ($type eq 'command') {
	return &text("log_${action}",
		     "<tt>".&html_escape($p->{'desc'})."</tt>");
	}
elsif ($type eq 'edit') {
	return &text("log_${action}_edit",
		     "<tt>".&html_escape($p->{'desc'})."</tt>");
	}
else {
	return undef;
	}
}

