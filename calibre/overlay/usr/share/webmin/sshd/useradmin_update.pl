
do 'sshd-lib.pl';

# useradmin_create_user(&details)
# Setup SSH and GNUPG for new users
sub useradmin_create_user
{
if ($config{'sync_create'} && &has_command($config{'keygen_path'}) &&
    -d $_[0]->{'home'} && !-d "$_[0]->{'home'}/.ssh") {
	local $cmd;
	local $type = $config{'sync_type'} ? "-t $config{'sync_type'}" :
		      $version{'type'} eq 'openssh' &&
		       $version{'number'} >= 3.2 ? "-t rsa1" : "";
	if ($config{'sync_pass'} && $_[0]->{'passmode'} == 3) {
		$cmd = "$config{'keygen_path'} $type -P \"$_[0]->{'plainpass'}\"";
		}
	else {
		$cmd = "$config{'keygen_path'} $type -P \"\"";
		}
	&system_logged("echo '' | su $_[0]->{'user'} -c '$cmd' >/dev/null 2>&1");
	if ($config{'sync_auth'}) {
		if (-r "$_[0]->{'home'}/.ssh/identity.pub") {
			&system_logged("cp $_[0]->{'home'}/.ssh/identity.pub $_[0]->{'home'}/.ssh/authorized_keys");
			}
		else {
			&system_logged("cp $_[0]->{'home'}/.ssh/id_dsa.pub $_[0]->{'home'}/.ssh/authorized_keys");
			}
		&system_logged("chown $_[0]->{'uid'}:$_[0]->{'gid'} $_[0]->{'home'}/.ssh/authorized_keys");
		}
	}
}

# useradmin_delete_user(&details)
sub useradmin_delete_user
{
}

# useradmin_modify_user(&details)
sub useradmin_modify_user
{
}

1;

