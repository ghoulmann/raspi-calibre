#!/usr/bin/perl
# update_sched.cgi
# Schedule the auto-updating of webmin modules

require './webmin-lib.pl';
&foreign_require("cron", "cron-lib.pl");
&ReadParse();
&error_setup($text{'update_err'});

# Validate inputs
&lock_file("$module_config_directory/config");
if ($in{'source'} == 0) {
	$config{'upsource'} = undef;
	}
else {
	@urls = ( );
	foreach $url (split(/\r?\n/, $in{'other'})) {
		$url =~ /^http:\/\/([^:\/]+)(:(\d+))?(\/\S*)$/ ||
			&error($text{'update_eurl'});
		push(@urls, $url);
		}
	@urls || &error($text{'update_eurl'});
	$config{'upsource'} = join("\t", @urls);
	}
$config{'update'} = $in{'enabled'};
if ($config{'cron_mode'} == 0) {
	$in{'hour'} =~ /^\d+$/ && $in{'hour'} < 24 ||
		&error($text{'update_ehour'});
	$config{'uphour'} = $in{'hour'};
	$in{'mins'} =~ /^\d+$/ && $in{'mins'} < 60 ||
		&error($text{'update_emins'});
	$config{'upmins'} = $in{'mins'};
	$in{'days'} =~ /^\d+$/ ||
		&error($text{'update_edays'});
	$config{'updays'} = $in{'days'};
	}
$config{'upshow'} = $in{'show'};
$config{'upmissing'} = $in{'missing'};
$config{'upthird'} = $in{'third'};
$config{'upquiet'} = $in{'quiet'};
$config{'upchecksig'} = $in{'checksig'};
$config{'upemail'} = $in{'email'};
$config{'upuser'} = $in{'upuser'};
$config{'uppass'} = $in{'uppass'};
!$in{'show'} || $in{'email'} || &error($text{'update_eemail'});
&write_file("$module_config_directory/config", \%config);
&unlock_file("$module_config_directory/config");

# Setup the cron job
@jobs = &cron::list_cron_jobs();
$job = &find_cron_job(\@jobs);
&lock_file($cron_cmd);
if ($job) {
	&cron::delete_cron_job($job);
	unlink($cron_cmd);
	}
if ($in{'enabled'}) {
	# Create the program that cron calls
	&cron::create_wrapper($cron_cmd, $module_name, "update.pl");

	$njob = { 'user' => 'root', 'active' => 1,
		  'command' => $cron_cmd };
	if ($config{'cron_mode'} == 0) {
		# Setup the actual cron job, simply
		if ($in{'days'} == 1) {
			@days = ( "*" );
			}
		else {
			for($i=1; $i<=31; $i+=$in{'days'}) {
				push(@days, $i);
				}
			}
		$njob->{'mins'} = $in{'mins'};
		$njob->{'hours'} = $in{'hour'};
		$njob->{'days'} = join(",",@days);
		$njob->{'months'} = '*';
		$njob->{'weekdays'} = '*';
		}
	else {
		# Create complex cron job
		&cron::parse_times_input($njob, \%in);
		}
	&foreign_call("cron", "create_cron_job", $njob);
	}
&unlock_file($cron_cmd);
&redirect("");


