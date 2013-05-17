# postcode.t

use Test::Most;

use Geo::UK::Postcode;

use lib 't/lib';
use TestGeoUKPostcode;

my $pkg = 'Geo::UK::Postcode';

dies_ok { $pkg->new() } "dies with no argument";

foreach my $test ( TestGeoUKPostcode->test_pcs() ) {

    test_pc( { %{$test}, raw => $_ } )
        foreach TestGeoUKPostcode->get_format_list( $test->{raw} );

    test_pc( { %{$test}, raw => lc $_ } )
        foreach TestGeoUKPostcode->get_format_list( $test->{raw} );
}

sub test_pc {
    my $test = shift;

    note $test->{raw};

    ok my $pc = $pkg->new( $test->{raw} ), "create pc object";
    isa_ok $pc, 'Geo::UK::Postcode';

    is $pc->$_, $test->{$_}, "$_ ok"
        foreach qw/ area district subdistrict sector unit outcode incode /;

    is $pc->outward, $test->{outcode}, 'outward ok';
    is $pc->inward,  $test->{incode},  'inward ok';

    is $pc->fixed_format, $test->{fixed_format}, "fixed format ok";

    my $str = $test->{outcode} . ' ' . $test->{incode};
    is $pc->as_string, $str, "as_string ok";

    is "$pc", $str, "stringify ok";

    foreach (qw/ strict valid partial non_geographical /) {
        is $pc->$_, $test->{$_} || 0,
            $test->{$_} ? "postcode is $_" : "postcode isn't $_";
    }

}

done_testing();

