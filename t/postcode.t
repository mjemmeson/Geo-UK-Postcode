# postcode.t

use Test::Most;

use Geo::UK::Postcode;

use lib 't/lib';
use TestGeoUKPostcode;

my $pkg = 'Geo::UK::Postcode';

dies_ok { $pkg->new() } "dies with no argument";

foreach my $test ( TestGeoUKPostcode->test_pcs( { valid => 1 } ) ) {

    test_pc( { %{$test}, raw => $_ } )
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
}

done_testing();

