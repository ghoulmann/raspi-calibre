#!/usr/bin/perl
# copyconfig.pl
# Copy the appropriate config file for each module into the webmin config
# directory. If it is already there, merge in new directives. Called with
# <osname> <osversion> <install dir> <config dir> <module>+

@ARGV >= 4 || die "usage: copyconfig.pl <os>[/real-os] <version>[/real-version] <webmin-dir> <config-dir> [module ...]";
$os = $ARGV[0];
$ver = $ARGV[1];
$wadir = $ARGV[2];
$confdir = $ARGV[3];
($os, $real_os) = split(/\//, $os);
($ver, $real_ver) = split(/\//, $ver);
$real_os =~ s/ /-/g;
$real_ver =~ s/ /-/g;

# Find all clones
opendir(DIR, $wadir);
foreach $f (readdir(DIR)) {
	if (readlink("$wadir/$f")) {
		@st = stat("$wadir/$f");
		push(@{$clone{$st[1]}}, $f);
		}
	}
closedir(DIR);

# For each module, copy its config to itself and all clones
@mods = @ARGV[4..$#ARGV];
foreach $m (@mods) {
	# Find any range-number config files. Search first by real OS type
	# (ie Ubuntu 6.1), then by internal OS code (ie. debian-linux 3.1)
	$srcdir = "$wadir/$m";
	$rangefile = $real_rangefile = undef;
	foreach $ov ([ $real_os, $real_ver, \$real_rangefile ],
		     [ $os, $ver, \$rangefile ]) {
		my ($o, $v, $rf) = @$ov;
		opendir(DIR, $srcdir);
		while($f = readdir(DIR)) {
			if ($f =~ /^config\-\Q$o\E\-([0-9\.]+)\-([0-9\.]+)$/ &&
			    $v >= $1 && $v <= $2) {
				$$rf = "$srcdir/$f";
				}
			elsif ($f =~ /^config\-\Q$o\E\-([0-9\.]+)\-(\*|ALL)$/ &&
			       $v >= $1) {
				$$rf = "$srcdir/$f";
				}
			elsif ($f =~ /^config\-\Q$o\E\-(\*|ALL)\-([0-9\.]+)$/ &&
			       $v <= $2) {
				$$rf = "$srcdir/$f";
				}
			}
		closedir(DIR);
		}

	# Find the best-matching config file. Search first by real OS type,
	# then by internal OS code

	# Check for real OS match by name and version, version range, or
	# name only
	if (-r "$srcdir/config-$real_os-$real_ver") {
		$conf = "$srcdir/config-$real_os-$real_ver";
		}
	elsif ($real_rangefile) {
		$conf = $real_rangefile;
		}
	elsif (-r "$srcdir/config-$real_os") {
		$conf = "$srcdir/config-$real_os";
		}

	# Check for OS code match by name and version, version range, or name
	elsif (-r "$srcdir/config-$os-$ver") {
		$conf = "$srcdir/config-$os-$ver";
		}
	elsif ($rangefile) {
		$conf = $rangefile;
		}
	elsif (-r "$srcdir/config-$os") {
		$conf = "$srcdir/config-$os";
		}

	# Check for config for an entire OS class, like *-linux
	elsif ($os =~ /^(\S+)-(\S+)$/ && -r "$srcdir/config-ALL-$2") {
		$conf = "$srcdir/config-ALL-$2";
		}
	elsif ($os =~ /^(\S+)-(\S+)$/ && -r "$srcdir/config-*-$2") {
		$conf = "$srcdir/config-*-$2";
		}

	# Use default config file, if it exists
	elsif (-r "$srcdir/config") {
		$conf = "$srcdir/config";
		}
	else {
		$conf = "/dev/null";
		}

	@st = stat($srcdir);
	@copyto = ( @{$clone{$st[1]}}, $m );
	foreach $c (@copyto) {
		if (!-d "$confdir/$c") {
			# New module .. need to create config dir
			mkdir("$confdir/$c", 0755);
			push(@newmods, $c);
			}
		undef(%oldconf); undef(%newconf);
		&read_file("$confdir/$c/config", \%oldconf);
		&read_file($conf, \%newconf);
		foreach $k (keys %oldconf) {
			$newconf{$k} = $oldconf{$k};
			}
		&write_file("$confdir/$c/config", \%newconf);
		}
	}
print join(" ", @newmods),"\n";

# read_file(file, array)
# Fill an associative array with name=value pairs from a file
sub read_file
{
local($arr);
$arr = $_[1];
open(ARFILE, $_[0]) || return 0;
while(<ARFILE>) {
	s/\r|\n//g;
        if (!/^#/ && /^([^=]+)=(.*)$/) { $$arr{$1} = $2; }
        }
close(ARFILE);
return 1;
}
 
# write_file(file, array)
# Write out the contents of an associative array as name=value lines
sub write_file
{
local($arr);
$arr = $_[1];
open(ARFILE, "> $_[0]");
foreach $k (keys %$arr) {
        print ARFILE "$k=$$arr{$k}\n";
        }
close(ARFILE);
}
