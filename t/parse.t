# parse.t

use Test::Most;

use Clone qw/ clone /;
use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';

note "parse";

my %tests = (
    'X'        => undef,
    'XX1'      => undef,
    'XX11'     => undef,
    'XX1X'     => undef,
    'XX1X1'    => undef,
    'XX11X1XX' => undef,

    'A1 1AA' => {
        area        => 'A',
        district    => '1',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA'
    },
    'A11 1AA' => {
        area        => 'A',
        district    => '11',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA'
    },
    'AA1 1AA' => {
        area        => 'AA',
        district    => '1',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA'
    },
    'AA11 1AA' => {
        area        => 'AA',
        district    => '11',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA'
    },
    'A1A 1AA' => {
        area        => 'A',
        district    => '1',
        subdistrict => 'A',
        sector      => '1',
        unit        => 'AA'
    },
    'AA1A 1AA' => {
        area        => 'AA',
        district    => '1',
        subdistrict => 'A',
        sector      => '1',
        unit        => 'AA'
    },
    'AB10 1AA' => {
        area          => 'AB',
        district      => '10',
        subdistrict   => undef,
        sector        => 1,
        unit          => 'AA',
        strict        => 1,
        valid_outcode => 1,
    },

);

test_parse( \%tests );

note "parse - strict";

test_parse( \%tests, { strict => 1 } );

note "parse - valid outcode";

test_parse( \%tests, { valid_outcode => 1 } );

sub msg {
    my ( $pc, $expected ) = @_;
    return $expected ? "$pc parsed as expected" : "$pc invalid as expected";
}

sub test_parse {
    my ( $tests, $options ) = @_;

    $options ||= {};

    foreach my $pc ( sort keys %{$tests} ) {

        my $expected = clone $tests{$pc};

        my $strict = $expected ? delete $expected->{strict} : undef;
        my $valid_outcode
            = $expected ? delete $expected->{valid_outcode} : undef;

        $expected = undef if $options->{strict}        && !$strict;
        $expected = undef if $options->{valid_outcode} && !$valid_outcode;

        my $parsed = $pkg->parse( $pc, $options );

        is_deeply $parsed, $expected, msg( $pc, $expected );

        # and without space
        $pc =~ s/\s//;
        $parsed = $pkg->parse( $pc, $options );

        is_deeply $parsed, $expected, msg( $pc, $expected );
    }
}

done_testing();

