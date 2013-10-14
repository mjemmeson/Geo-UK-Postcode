# regex.t

use Test::Most;

use Geo::UK::Postcode::Regex qw/ is_valid_pc is_strict_pc is_lax_pc /;

use lib 't/lib';
use TestGeoUKPostcode;

my $pkg = 'Geo::UK::Postcode::Regex';

ok my $re        = $pkg->regex,        "regex";
ok my $strict_re = $pkg->strict_regex, "strict_regex";
ok my $valid_re  = $pkg->valid_regex,  "valid_regex";

ok my $re_partial        = $pkg->regex_partial,        "regex_partial";
ok my $strict_re_partial = $pkg->strict_regex_partial, "strict_regex_partial";
ok my $valid_re_partial  = $pkg->valid_regex_partial,  "valid_regex_partial";

foreach my $test ( TestGeoUKPostcode->test_pcs ) {

    foreach my $pc ( TestGeoUKPostcode->get_format_list($test) ) {
        note $pc;

        unless ( $test->{partial} ) {

	    if ($test->{strict}) {
		ok is_strict_pc( $pc ), "is_strict_pc true";
	    } else {
		ok !is_strict_pc( $pc ), "is_strict_pc false";
	    }

	    if ($test->{valid}) {
		ok is_valid_pc( $pc ), "is_valid_pc true";
	    } else {
		ok !is_valid_pc( $pc ), "is_valid_pc false";
	    }

	    ok is_lax_pc( $pc ), "is_lax_pc true";

            ok $pc =~ $re, "$pc matches lax regex";

            if ( $test->{strict} ) {
                ok $pc =~ $strict_re, "$pc matches strict regex";
            } else {
                ok $pc !~ $strict_re, "$pc doesn't match strict regex";
            }

            if ( $test->{valid} ) {
                ok $pc =~ $valid_re, "$pc matches valid regex";
            } else {
                ok $pc !~ $valid_re, "$pc doesn't match valid regex";
            }
        }

        ok $pc =~ $re_partial, "$pc matches lax regex partial";

        if ( $test->{strict} ) {
            ok $pc =~ $strict_re_partial, "$pc matches strict regex partial";
        } else {
            ok $pc !~ $strict_re_partial,
                "$pc doesn't match strict regex partial";
        }

        if ( $test->{valid} ) {
            ok $pc =~ $valid_re_partial, "$pc matches valid regex partial";
        } else {
            ok $pc !~ $valid_re_partial,
                "$pc doesn't match valid regex partial";
        }
    }
}

done_testing();

