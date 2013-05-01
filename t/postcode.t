# postcode.t

use Test::Most;

use Geo::UK::Postcode;

my $pkg = 'Geo::UK::Postcode';

dies_ok { $pkg->new() } "dies with no argument";

my @tests = (
    {   raw          => 'ab1 2cd',
        area         => 'AB',
        district     => '1',
        subdistrict  => undef,
        sector       => '2',
        unit         => 'CD',
        outcode      => 'AB1',
        incode       => '2CD',
        fixed_format => 'AB1  2CD',
    },
    {   raw          => 'wc1h 9eb',
        area         => 'WC',
        district     => '1',
        subdistrict  => 'H',
        sector       => '9',
        unit         => 'EB',
        outcode      => 'WC1H',
        incode       => '9EB',
        fixed_format => 'WC1H 9EB',
    },
);

foreach my $test (@tests) {

    my $raw = $test->{raw};

    test_pc( { %{$test}, raw => $raw } );
    test_pc( { %{$test}, raw => uc $raw } );

    $raw =~ s/ /  /;

    test_pc( { %{$test}, raw => $raw } );
    test_pc( { %{$test}, raw => uc $raw } );

    ( $raw = $test->{raw} ) =~ s/\s//g;

    test_pc( { %{$test}, raw => $raw } );
    test_pc( { %{$test}, raw => uc $raw } );

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

