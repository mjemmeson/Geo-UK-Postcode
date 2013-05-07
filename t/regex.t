# regex.t

use Test::Most;

use Geo::UK::Postcode::Regex;

use lib 't/lib';
use TestGeoUKPostcode;

my $pkg = 'Geo::UK::Postcode::Regex';

ok my $re       = $pkg->regex,       "regex";
ok my $loose_re = $pkg->loose_regex, "loose_regex";

foreach my $test ( TestGeoUKPostcode->test_pcs ) {

    foreach my $pc ( TestGeoUKPostcode->get_format_list( $test->{raw} ) ) {
        note $pc;

        ok $pc =~ $loose_re, "$pc matches loose_regex";

        if ( $test->{valid} ) {
            ok $pc =~ $re, "$pc matches strict regex";
        } else {
            ok $pc !~ $re, "$pc doesn't match strict regex";
        }
    }
}

done_testing();

