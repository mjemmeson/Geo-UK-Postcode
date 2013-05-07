# valid_geographical.t

use Test::Most;

use Data::Dumper::Concise;
use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';

my $re       = $pkg->regex;
my $loose_re = $pkg->loose_regex;

my @failures;

while (<>) {

    chomp;
    s/\s+/ /;
    push @failures, $_ unless /$loose_re/;
}

ok( !@failures, "all geographical postcodes passed loose regex" )
    or warn Dumper( [ sort @failures ] );

done_testing();

