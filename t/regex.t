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

    foreach my $raw ( TestGeoUKPostcode->get_format_list($test) ) {

        note $raw;

        unless ( $test->{partial} ) {

            if ( $test->{strict} ) {
                ok is_strict_pc($raw), "is_strict_pc true";
                ok $raw =~ $strict_re, "$raw matches strict regex";
            } else {
                ok !is_strict_pc($raw), "is_strict_pc false";
                ok $raw !~ $strict_re, "$raw doesn't match strict regex";
            }

            if ( $test->{valid_outcode} && $test->{strict} ) {
                ok is_valid_pc($raw), "is_valid_pc true";
                ok $raw =~ $valid_re, "$raw matches valid regex";
            } else {
                ok !is_valid_pc($raw), "is_valid_pc false";
                ok $raw !~ $valid_re, "$raw doesn't match valid regex";
            }

            if ( $test->{area} ) {
                ok is_lax_pc($raw), "is_lax_pc true";
                ok $raw =~ $re, "$raw matches lax regex";
            } else {
                ok !is_lax_pc($raw), "is_lax_pc false";
                ok $raw !~ $re, "$raw doesn't match lax regex";
            }

        }

        if ( $test->{area} ) {
            ok $raw =~ $re_partial, "$raw matches lax regex partial";
        } else {
            ok $raw !~ $re_partial, "$raw doesn't match lax regex partial";
        }

        if ( $test->{strict} ) {
            ok $raw =~ $strict_re_partial, "$raw matches strict regex partial";
        } else {
            ok $raw !~ $strict_re_partial,
                "$raw doesn't match strict regex partial";
        }

        if ( $test->{valid_outcode} && $test->{strict} ) {
            ok $raw =~ $valid_re_partial, "$raw matches valid regex partial";
        } else {
            ok $raw !~ $valid_re_partial,
                "$raw doesn't match valid regex partial";
        }
    }
}

done_testing();

