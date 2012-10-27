# Functions for MD5 and SHA1 password encryption

# check_md5()
# Returns a perl module name if the needed perl module(s) for MD5 encryption
# are not installed, or undef if they are
sub check_md5
{
# On some systems, the crypt function just works!
return undef if (&unix_crypt_supports_md5());

# Try Perl modules
eval "use MD5";
if (!$@) {
	eval "use Digest::MD5";
	if ($@) {
		return "Digest::MD5";
		}
	}
return undef;
}

# encrypt_md5(string, [salt])
# Returns a string encrypted in MD5 format
sub encrypt_md5
{
local $passwd = $_[0];
local $salt = $_[1];
local $magic = '$1$';
if ($salt =~ /^\$1\$([^\$]+)/) {
	# Extract actual salt from already encrypted password
	$salt = $1;
	}
if ($salt !~ /^[a-z0-9\/\.]{8}$/i) {
	# Non-MD5 salt
	$salt = undef;
	}
$salt ||= substr(time(), -8);

# Use built-in crypt support for MD5, if we can
if (&unix_crypt_supports_md5()) {
	return crypt($passwd, $magic.$salt.'$xxxxxxxxxxxxxxxxxxxxxx');
	}

# Add the password, magic and salt
local $cls = "MD5";
eval "use MD5";
if ($@) {
	$cls = "Digest::MD5";
	eval "use Digest::MD5";
	if ($@) {
		&error("Missing MD5 or Digest::MD5 perl modules");
		}
	}
local $ctx = eval "new $cls";
$ctx->add($passwd);
$ctx->add($magic);
$ctx->add($salt);

# Add some more stuff from the hash of the password and salt
local $ctx1 = eval "new $cls";
$ctx1->add($passwd);
$ctx1->add($salt);
$ctx1->add($passwd);
local $final = $ctx1->digest();
for($pl=length($passwd); $pl>0; $pl-=16) {
	$ctx->add($pl > 16 ? $final : substr($final, 0, $pl));
	}

# This piece of code seems rather pointless, but it's in the C code that
# does MD5 in PAM so it has to go in!
local $j = 0;
local ($i, $l);
for($i=length($passwd); $i; $i >>= 1) {
	if ($i & 1) {
		$ctx->add("\0");
		}
	else {
		$ctx->add(substr($passwd, $j, 1));
		}
	}
$final = $ctx->digest();

# This loop exists only to waste time
for($i=0; $i<1000; $i++) {
	$ctx1 = eval "new $cls";
	$ctx1->add($i & 1 ? $passwd : $final);
	$ctx1->add($salt) if ($i % 3);
	$ctx1->add($passwd) if ($i % 7);
	$ctx1->add($i & 1 ? $final : $passwd);
	$final = $ctx1->digest();
	}

# Convert the 16-byte final string into a readable form
local $rv = $magic.$salt.'$';
local @final = map { ord($_) } split(//, $final);
$l = ($final[ 0]<<16) + ($final[ 6]<<8) + $final[12];
$rv .= &to64($l, 4);
$l = ($final[ 1]<<16) + ($final[ 7]<<8) + $final[13];
$rv .= &to64($l, 4);
$l = ($final[ 2]<<16) + ($final[ 8]<<8) + $final[14];
$rv .= &to64($l, 4);
$l = ($final[ 3]<<16) + ($final[ 9]<<8) + $final[15];
$rv .= &to64($l, 4);
$l = ($final[ 4]<<16) + ($final[10]<<8) + $final[ 5];
$rv .= &to64($l, 4);
$l = $final[11];
$rv .= &to64($l, 2);

return $rv;
}

# unix_crypt_supports_md5()
# Returns 1 if the built-in crypt() function can already do MD5
sub unix_crypt_supports_md5
{
my $hash = '$1$A9wB3O18$zaZgqrEmb9VNltWTL454R/';
my $newhash = eval { crypt('test', $hash) };
return $newhash eq $hash;
}

@itoa64 = split(//, "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
sub to64
{
local ($v, $n) = @_;
local $r;
while(--$n >= 0) {
        $r .= $itoa64[$v & 0x3f];
        $v >>= 6;
        }
return $r;
}

sub check_sha1
{
eval "use Digest::SHA1";
return $@ ? "Digest::SHA1" : undef;
}

# encrypt_sha1(password)
# Encrypts a password in SHA1 format
sub encrypt_sha1
{
local $pass = $_[0];
local $sh = eval "use Digest::SHA1 qw(sha1_base64);return sha1_base64(\$pass);";
return "{SHA}$sh=";
}

# encrypt_sha1_hash(password, salt)
# Hashes a combined salt+password with SHA1, and returns it in hex. Used on OSX
sub encrypt_sha1_hash
{
local ($pass, $salt) = @_;
# XXX not done yet??
}

# check_blowfish()
# Returns an missing Perl module if blowfish is not available, undef if OK
sub check_blowfish
{
eval "use Crypt::Eksblowfish::Bcrypt";
return $@ ? "Crypt::Eksblowfish::Bcrypt" : undef;
}

# encrypt_blowfish(password, [salt])
# Returns a string encrypted in blowfish format, suitable for /etc/shadow
sub encrypt_blowfish
{
local ($passwd, $salt) = @_;
local ($plain, $base64);
eval "use Crypt::Eksblowfish::Bcrypt";
if ($salt !~ /^\$2a\$/) {
	# Invalid salt for Blowfish
	$salt = undef;
	}
if (!$salt) {
	# Generate a 22-character base-64 format salt
	&seed_random();
	while(length($base64) < 22) {
		$plain .= chr(int(rand()*96)+32);
		$base64 = Crypt::Eksblowfish::Bcrypt::en_base64($plain);
		}
	$base64 = substr($base64, 0, 22);
	$salt = '$2a$'.'08'.'$'.$base64;
	}
return Crypt::Eksblowfish::Bcrypt::bcrypt($passwd, $salt);
}

# unix_crypt_supports_sha512()
# Returns 1 if the built-in crypt() function can already do SHA512
sub unix_crypt_supports_sha512
{
my $hash = '$6$Tk5o/GEE$zjvXhYf/dr5M7/jan3pgunkNrAsKmQO9r5O8sr/Cr1hFOLkWmsH4iE9hhqdmHwXd5Pzm4ubBWTEjtMeC.h5qv1';
my $newhash = eval { crypt('test', $hash) };
return $newhash eq $hash;
}

# check_sha512()
# Returns undef if SHA512 hashing is supported, or an error message if not
sub check_sha512
{
return &unix_crypt_supports_sha512() ? undef : 'Crypt::SHA';
}

# encrypt_sha512(password, [salt])
# Hashes a password, possibly with the give salt, with SHA512
sub encrypt_sha512
{
local ($passwd, $salt) = @_;
$salt ||= '$6$'.substr(time(), -8).'$';
return crypt($passwd, $salt);
}

# validate_password(password, hash)
# Compares a password with a hash to see if they match, returns 1 if so,
# 0 otherwise. Tries all supported hashing schemes.
sub validate_password
{
local ($passwd, $hash) = @_;

# Classic Unix crypt
local $chash = eval {
	local $main::error_must_die = 1;
	&unix_crypt($passwd, $hash);
	};
return 1 if ($chash eq $hash);

# MD5
if (!&check_md5()) {
	local $mhash = &encrypt_md5($passwd, $hash);
	return 1 if ($mhash eq $hash);
	}

# Blowfish
if (!&check_blowfish()) {
	local $mhash = &encrypt_blowfish($passwd, $hash);
	return 1 if ($mhash eq $hash);
	}

# SHA1
if (!&check_sha512()) {
	local $shash = &encrypt_sha512($passwd, $hash);
	return 1 if ($shash eq $hash);
	}

# Some other hashing, maybe supported by crypt
local $ohash = eval { crypt($passwd, $hash) };
return 1 if ($ohash eq $hash);

return 0;
}

1;

