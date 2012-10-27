
require 'user-lib.pl';

# acl_security_form(&options)
# Output HTML for editing security options for the useradmin module
sub acl_security_form
{
local $o = $_[0];

print "<tr> <td valign=top><b>$text{'acl_uedit'}</b></td> <td colspan=3>\n";
printf "<input type=radio name=uedit_mode value=0 %s> $text{'acl_uedit_all'}&nbsp;&nbsp;\n",
	$o->{'uedit_mode'} == 0 ? "checked" : "";
printf "<input type=radio name=uedit_mode value=1 %s> $text{'acl_uedit_none'}&nbsp;\n",
	$o->{'uedit_mode'} == 1 ? "checked" : "";
printf "<input type=radio name=uedit_mode value=6 %s> $text{'acl_uedit_this'}<br>\n",
	$o->{'uedit_mode'} == 6 ? "checked" : "";
printf "<input type=radio name=uedit_mode value=2 %s> $text{'acl_uedit_only'}\n",
	$o->{'uedit_mode'} == 2 ? "checked" : "";
printf "<input name=uedit_can size=40 value='%s'> %s<br>\n",
	$o->{'uedit_mode'} == 2 ? $o->{'uedit'} : "",
	&user_chooser_button("uedit_can", 1);
printf "<input type=radio name=uedit_mode value=3 %s> $text{'acl_uedit_except'}\n",
	$o->{'uedit_mode'} == 3 ? "checked" : "";
printf "<input name=uedit_cannot size=40 value='%s'> %s<br>\n",
	$o->{'uedit_mode'} == 3 ? $o->{'uedit'} : "",
	&user_chooser_button("uedit_cannot", 1);
printf "<input type=radio name=uedit_mode value=4 %s> $text{'acl_uedit_uid'}\n",
	$o->{'uedit_mode'} == 4 ? "checked" : "";
printf "<input name=uedit_uid size=6 value='%s'> - \n",
	$o->{'uedit_mode'} == 4 ? $o->{'uedit'} : "";
printf "<input name=uedit_uid2 size=6 value='%s'><br>\n",
	$o->{'uedit_mode'} == 4 ? $o->{'uedit2'} : "";
printf "<input type=radio name=uedit_mode value=5 %s> $text{'acl_uedit_group'}\n",
	$o->{'uedit_mode'} == 5 ? "checked" : "";
printf "<input name=uedit_group size=40 value='%s'> %s<br>\n",
	$o->{'uedit_mode'} == 5 ?
	 join(" ", map { "".&my_getgrgid($_) } split(/\s+/, $o->{'uedit'})) :"",
	&group_chooser_button("uedit_group", 1);
printf "%s <input type=checkbox name=uedit_sec value=1 %s> %s<br>\n",
	"&nbsp;" x 5, $o->{'uedit_sec'} ? 'checked' : '',$text{'acl_uedit_sec'};
printf "<input type=radio name=uedit_mode value=7 %s> $text{'acl_uedit_re'}\n",
	$o->{'uedit_mode'} == 7 ? "checked" : "";
printf "<input name=uedit_re size=40 value='%s'> %s<br>\n",
	$o->{'uedit_mode'} == 7 ? $o->{'uedit_re'} : "";
print "</td> </tr>\n";

print "<tr> <td><b>$text{'acl_ucreate'}</b></td> <td>\n";
printf "<input type=radio name=ucreate value=1 %s> $text{'yes'}\n",
	$o->{'ucreate'} ? "checked" : "";
printf "<input type=radio name=ucreate value=0 %s> $text{'no'}</td> </tr>\n",
	$o->{'ucreate'} ? "" : "checked";

print "<tr> <td><b>$text{'acl_batch'}</b></td> <td>\n";
printf "<input type=radio name=batch value=1 %s> $text{'yes'}\n",
	$o->{'batch'} ? "checked" : "";
printf "<input type=radio name=batch value=0 %s> $text{'no'}</td> </tr>\n",
	$o->{'batch'} ? "" : "checked";

print "<tr> <td><b>$text{'acl_export'}</b></td> <td colspan=3>\n";
printf "<input type=radio name=export value=2 %s> $text{'yes'}\n",
	$o->{'export'} == 2 ? "checked" : "";
printf "<input type=radio name=export value=1 %s> $text{'acl_export1'}\n",
	$o->{'export'} == 1 ? "checked" : "";
printf "<input type=radio name=export value=0 %s> $text{'no'}</td> </tr>\n",
	$o->{'export'} == 0 ? "checked" : "";

print "<tr> <td valign=top><b>$text{'acl_uid'}</b></td>\n";
print "<td colspan=3><input name=lowuid size=6 value='$o->{'lowuid'}'> -\n";
print "<input name=hiuid size=6 value='$o->{'hiuid'}'><br>\n";
printf "<input type=checkbox name=autouid value=1 %s> %s<br>\n",
	$o->{'autouid'} ? "checked" : "", $text{'acl_autouid'};
printf "<input type=checkbox name=calcuid value=1 %s> %s<br>\n",
	$o->{'calcuid'} ? "checked" : "", $text{'acl_calcuid'};
printf "<input type=checkbox name=useruid value=1 %s> %s<br>\n",
	$o->{'useruid'} ? "checked" : "", $text{'acl_useruid'};
printf "<input type=checkbox name=umultiple value=1 %s> %s<br>\n",
	$o->{'umultiple'} ? "checked" : "", $text{'acl_umultiple'};
printf "<input type=checkbox name=uuid value=1 %s> %s</td> </tr>\n",
	$o->{'uuid'} ? "checked" : "", $text{'acl_uuid'};

local $uedit_gmode = defined($o->{'uedit_gmode'}) ? $o->{'uedit_gmode'} :
		     $o->{'ugroups'} eq '*' ? 0 : 2;
print "<tr> <td valign=top><b>$text{'acl_ugroups'}</b></td> <td colspan=3>\n";
printf "<input type=radio name=uedit_gmode value=0 %s> $text{'acl_gedit_all'}<br>\n",
	$uedit_gmode == 0 ? "checked" : "";
printf "<input type=radio name=uedit_gmode value=2 %s> $text{'acl_gedit_only'}\n",
	$uedit_gmode == 2 ? "checked" : "";
printf "<input name=uedit_gcan size=40 value='%s'> %s<br>\n",
	$uedit_gmode == 2 ? $o->{'ugroups'} : "",
	&group_chooser_button("uedit_gcan", 1);
printf "<input type=radio name=uedit_gmode value=3 %s> $text{'acl_gedit_except'}\n",
	$uedit_gmode == 3 ? "checked" : "";
printf "<input name=uedit_gcannot size=40 value='%s'> %s<br>\n",
	$uedit_gmode == 3 ? $o->{'ugroups'} : "",
	&group_chooser_button("uedit_gcannot", 1);
printf "<input type=radio name=uedit_gmode value=4 %s> $text{'acl_gedit_gid'}\n",
	$uedit_gmode == 4 ? "checked" : "";
printf "<input name=uedit_gid size=6 value='%s'> -\n",
	$uedit_gmode == 4 ? $o->{'ugroups'} : "";
printf "<input name=uedit_gid2 size=6 value='%s'></td> </tr>\n",
	$uedit_gmode == 4 ? $o->{'ugroups2'} : "";

print "<tr> <td valign=top><b>$text{'acl_shells'}</b></td> <td colspan=3>\n";
printf "<input type=radio name=shells_def value=1 %s> $text{'acl_any'}\n",
	$o->{'shells'} eq "*" ? "checked" : "";
printf "<input type=radio name=shells_def value=0 %s> $text{'acl_listed'}<br>\n",
	$o->{'shells'} eq "*" ? "" : "checked";
print "<textarea name=shells rows=3 cols=40>",
	$o->{'shells'} eq "*" ? "" : join("\n", split(/\s+/, $o->{'shells'})),
	"</textarea></td> </tr>\n";

print "<tr> <td><b>$text{'acl_epeopt'}</b></td> <td>\n";
printf "<input type=radio name=peopt value=1 %s> $text{'yes'}\n",
	$o->{'peopt'} ? "checked" : "";
printf "<input type=radio name=peopt value=0 %s> $text{'no'}</td> </tr>\n",
	$o->{'peopt'} ? "" : "checked";

print "<tr> <td valign=top><b>$text{'acl_home'}</b></td>\n";
printf "<td colspan=3><input name=home size=40 value='%s'> %s<br>\n",
	$o->{'home'}, &file_chooser_button("home", 1);
printf "<input type=checkbox name=autohome value=1 %s> %s</td> </tr>\n",
	$o->{'autohome'} ? "checked" : "",
	$text{'acl_autohome'};

print "<tr> <td><b>$text{'acl_udelete'}</b></td> <td>\n";
printf "<input type=radio name=udelete value=1 %s> $text{'yes'}\n",
	$o->{'udelete'} ? "checked" : "";
printf "<input type=radio name=udelete value=0 %s> $text{'no'}</td> </tr>\n",
	$o->{'udelete'} ? "" : "checked";

print "<tr> <td><b>$text{'acl_urename'}</b></td> <td>\n";
printf "<input type=radio name=urename value=1 %s> $text{'yes'}\n",
	$o->{'urename'} ? "checked" : "";
printf "<input type=radio name=urename value=0 %s> $text{'no'}</td> </tr>\n",
	$o->{'urename'} ? "" : "checked";

print "<tr> <td valign=top><b>$text{'acl_delhome'}</b></td>\n";
print "<td colspan=3>",&ui_radio("delhome", $o->{'delhome'},
			  [ [ 2, $text{'acl_option'} ],
			    [ 1, $text{'acl_always'} ],
			    [ 0, $text{'acl_never'} ] ]),"</td> </tr>\n";

# 0 = always on, 1 = can edit, 2 = always off
print "<tr> <td valign=top><b>$text{'acl_saveopts'}</b></td> ",
      "<td colspan=3><table>\n";
foreach $opt ('chuid', 'chgid', 'movehome', 'mothers',
	      'makehome', 'copy', 'cothers', 'dothers') {
	print "<tr> <td>",$text{"uedit_$opt"},"</td>\n";
	printf "<td><input type=radio name=$opt value=1 %s> %s\n",
		$o->{$opt} == 1 ? "checked" : "", $text{'acl_canedit'};
	printf "<input type=radio name=$opt value=0 %s> %s\n",
		$o->{$opt} == 0 ? "checked" : "", $text{'acl_on'};
	printf "<input type=radio name=$opt value=2 %s> %s</td> </tr>\n",
		$o->{$opt} == 2 ? "checked" : "", $text{'acl_off'};
	}
print "</table></td> </tr>\n";

print "<tr> <td colspan=4><hr></td> </tr>\n";

print "<tr> <td valign=top><b>$text{'acl_gedit'}</b></td> <td colspan=3>\n";
printf "<input type=radio name=gedit_mode value=0 %s> $text{'acl_gedit_all'}&nbsp;&nbsp;\n",
	$o->{'gedit_mode'} == 0 ? "checked" : "";
printf "<input type=radio name=gedit_mode value=1 %s> $text{'acl_gedit_none'}<br>\n",
	$o->{'gedit_mode'} == 1 ? "checked" : "";
printf "<input type=radio name=gedit_mode value=2 %s> $text{'acl_gedit_only'}\n",
	$o->{'gedit_mode'} == 2 ? "checked" : "";
printf "<input name=gedit_can size=40 value='%s'> %s<br>\n",
	$o->{'gedit_mode'} == 2 ? $o->{'gedit'} : "",
	&group_chooser_button("gedit_can", 1);
printf "<input type=radio name=gedit_mode value=3 %s> $text{'acl_gedit_except'}\n",
	$o->{'gedit_mode'} == 3 ? "checked" : "";
printf "<input name=gedit_cannot size=40 value='%s'> %s<br>\n",
	$o->{'gedit_mode'} == 3 ? $o->{'gedit'} : "",
	&group_chooser_button("gedit_cannot", 1);
printf "<input type=radio name=gedit_mode value=4 %s> $text{'acl_gedit_gid'}\n",
	$o->{'gedit_mode'} == 4 ? "checked" : "";
printf "<input name=gedit_gid size=6 value='%s'> -\n",
	$o->{'gedit_mode'} == 4 ? $o->{'gedit'} : "";
printf "<input name=gedit_gid2 size=6 value='%s'></td> </tr>\n",
	$o->{'gedit_mode'} == 4 ? $o->{'gedit2'} : "";

print "<tr> <td><b>$text{'acl_gcreate'}</b></td> <td colspan=3>\n";
printf "<input type=radio name=gcreate value=1 %s> $text{'yes'}\n",
	$o->{'gcreate'}==1 ? "checked" : "";
printf "<input type=radio name=gcreate value=2 %s> $text{'acl_gnew'}\n",
	$o->{'gcreate'}==2 ? "checked" : "";
printf "<input type=radio name=gcreate value=0 %s> $text{'no'}</td> </tr>\n",
	$o->{'gcreate'}==0 ? "checked" : "";

print "<tr> <td valign=top><b>$text{'acl_gid'}</b></td>\n";
print "<td colspan=3><input name=lowgid size=6 value='$o->{'lowgid'}'> -\n";
print "<input name=higid size=6 value='$o->{'higid'}'><br>\n";
printf "<input type=checkbox name=autogid value=1 %s> %s<br>\n",
	$o->{'autogid'} ? "checked" : "", $text{'acl_autogid'};
printf "<input type=checkbox name=calcgid value=1 %s> %s<br>\n",
	$o->{'calcgid'} ? "checked" : "", $text{'acl_calcgid'};
printf "<input type=checkbox name=usergid value=1 %s> %s<br>\n",
	$o->{'usergid'} ? "checked" : "", $text{'acl_usergid'};
printf "<input type=checkbox name=gmultiple value=1 %s> %s<br>\n",
	$o->{'gmultiple'} ? "checked" : "", $text{'acl_gmultiple'};
printf "<input type=checkbox name=ggid value=1 %s> %s</td> </tr>\n",
	$o->{'ggid'} ? "checked" : "", $text{'acl_ggid'};

print "<tr> <td><b>$text{'acl_gdelete'}</b></td> <td>\n";
printf "<input type=radio name=gdelete value=1 %s> $text{'yes'}\n",
	$o->{'gdelete'} ? "checked" : "";
printf "<input type=radio name=gdelete value=0 %s> $text{'no'}</td> </tr>\n",
	$o->{'gdelete'} ? "" : "checked";

print "<tr> <td colspan=4><hr></td> </tr>\n";

print "<tr><td valign=top><b>$text{'acl_logins'}</b></td> <td colspan=3>\n";
printf "<input type=radio name=logins_mode value=0 %s> $text{'acl_lnone'}<br>\n",
	$o->{'logins'} ? "" : "checked";
printf "<input type=radio name=logins_mode value=1 %s> $text{'acl_lall'}<br>\n",
	$o->{'logins'} eq "*" ? "checked" : "";
printf "<input type=radio name=logins_mode value=2 %s>\n",
	$o->{'logins'} =~ /[^\*]/ ? "checked" : "";
printf "<input name=logins size=40 value='%s'> %s</td> </tr>\n",
	$o->{'logins'} =~ /[^\*]/ ? $o->{'logins'} : "",
	&user_chooser_button("logins", 1);
}

# acl_security_save(&options)
# Parse the form for security options for the useradmin module
sub acl_security_save
{
$_[0]->{'lowuid'} = $in{'lowuid'};
$_[0]->{'hiuid'} = $in{'hiuid'};
$_[0]->{'autouid'} = $in{'autouid'};
$_[0]->{'autogid'} = $in{'autogid'};
$_[0]->{'calcuid'} = $in{'calcuid'};
$_[0]->{'calcgid'} = $in{'calcgid'};
$_[0]->{'useruid'} = $in{'useruid'};
$_[0]->{'usergid'} = $in{'usergid'};
$_[0]->{'lowgid'} = $in{'lowgid'};
$_[0]->{'higid'} = $in{'higid'};
$_[0]->{'uedit_mode'} = $in{'uedit_mode'};
$_[0]->{'uedit'} = $in{'uedit_mode'} == 2 ? $in{'uedit_can'} :
		   $in{'uedit_mode'} == 3 ? $in{'uedit_cannot'} :
		   $in{'uedit_mode'} == 4 ? $in{'uedit_uid'} :
		   $in{'uedit_mode'} == 5 ?
			join(" ", map { "".&my_getgrnam($_) }
			     split(/\s+/, $in{'uedit_group'})) : "";
$_[0]->{'uedit2'} = $in{'uedit_mode'} == 4 ? $in{'uedit_uid2'} : undef;
$_[0]->{'uedit_sec'} = $in{'uedit_mode'} == 5 ? $in{'uedit_sec'} : undef;
$_[0]->{'uedit_re'} = $in{'uedit_mode'} == 7 ? $in{'uedit_re'} : undef;
$_[0]->{'gedit_mode'} = $in{'gedit_mode'};
$_[0]->{'gedit'} = $in{'gedit_mode'} == 2 ? $in{'gedit_can'} :
		   $in{'gedit_mode'} == 3 ? $in{'gedit_cannot'} :
		   $in{'gedit_mode'} == 4 ? $in{'gedit_gid'} : "";
$_[0]->{'gedit2'} = $in{'gedit_mode'} == 4 ? $in{'gedit_gid2'} : undef;
$_[0]->{'ucreate'} = $in{'ucreate'};
$_[0]->{'gcreate'} = $in{'gcreate'};
if ($in{'uedit_gmode'} == 0) {
	delete($_[0]->{'uedit_gmode'});
	$_[0]->{'ugroups'} = "*";
	}
elsif ($in{'uedit_gmode'} == 2) {
	delete($_[0]->{'uedit_gmode'});
	$_[0]->{'ugroups'} = $in{'uedit_gcan'};
	}
else {
	$_[0]->{'uedit_gmode'} = $in{'uedit_gmode'};
	$_[0]->{'ugroups'} = $in{'uedit_gmode'} == 3 ? $in{'uedit_gcannot'} :
			     $in{'uedit_gmode'} == 4 ? $in{'uedit_gid'} : "";
	}
$_[0]->{'ugroups2'} = $in{'uedit_gmode'} == 4 ? $in{'uedit_gid2'} : undef;

$_[0]->{'logins'} = $in{'logins_mode'} == 0 ? "" :
		    $in{'logins_mode'} == 1 ? "*" : $in{'logins'};
$_[0]->{'shells'} = $in{'shells_def'} ? "*"
				      : join(" ", split(/\s+/, $in{'shells'}));
$_[0]->{'peopt'} = $in{'peopt'};
$_[0]->{'batch'} = $in{'batch'};
$_[0]->{'export'} = $in{'export'};
$_[0]->{'home'} = $in{'home'};
$_[0]->{'delhome'} = $in{'delhome'};
$_[0]->{'autohome'} = $in{'autohome'};
$_[0]->{'umultiple'} = $in{'umultiple'};
$_[0]->{'uuid'} = $in{'uuid'};
$_[0]->{'gmultiple'} = $in{'gmultiple'};
$_[0]->{'ggid'} = $in{'ggid'};
foreach $o ('chuid', 'chgid', 'movehome', 'mothers',
	    'makehome', 'copy', 'cothers', 'dothers') {
	$_[0]->{$o} = $in{$o};
	}
$_[0]->{'udelete'} = $in{'udelete'};
$_[0]->{'urename'} = $in{'urename'};
$_[0]->{'gdelete'} = $in{'gdelete'};
}

