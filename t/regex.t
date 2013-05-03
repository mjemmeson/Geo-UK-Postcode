# regex.t

use Test::Most;

use Geo::UK::Postcode;

use lib 't/lib';
use TestGeoUKPostcode;

my $pkg = 'Geo::UK::Postcode';

#ok my $re = $pkg->regex, "regex";
ok my $loose_re = $pkg->loose_regex, "loose_regex";

foreach my $test ( TestGeoUKPostcode->test_pcs ) {

    foreach my $pc ( TestGeoUKPostcode->get_format_list( $test->{raw} ) ) {

	

    }


}

done_testing();

