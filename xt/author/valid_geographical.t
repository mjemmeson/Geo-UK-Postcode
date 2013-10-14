# valid_geographical.t

# development tests - run against full Code-Point postcode database

use Test::Most;

use Data::Dumper::Concise;
use File::Slurp qw/ read_file /;
use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';

my $re     = $pkg->strict_regex;
my $lax_re = $pkg->regex;

my ( @failures, @strict_failures );

my $file = $ENV{HOME} . '/dev/postcodes/codepointopen_postcodes';

my @pcs = read_file $file;

foreach (@pcs) {
    chomp;
    push @failures,        $_ unless /$lax_re/;
    push @strict_failures, $_ unless /$re/;

    # try without space
    s/\s+/ /;
    push @failures,        $_ unless /$lax_re/;
    push @strict_failures, $_ unless /$re/;
}

ok( !@failures, "all geographical postcodes passed lax regex" )
    or warn Dumper( [ sort @failures ] );

ok( !@strict_failures, "all geographical postcodes passed strict regex" )
    or warn Dumper( [ sort @strict_failures ] );

done_testing();

