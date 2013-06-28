# parse.t

use Test::Most;

use Data::Dumper::Concise;
use Clone qw/ clone /;
use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';

my %tests = (
    'X'   => undef,
    'XX1' => {
        area        => 'XX',
        district    => '1',
        subdistrict => undef,
        sector      => undef,
        unit        => undef,
        partial     => 1,
    },
    'XX11' => {
        area        => 'XX',
        district    => '11',
        subdistrict => undef,
        sector      => undef,
        unit        => undef,
        partial     => 1,
    },
    'XX1X' => {
        area        => 'XX',
        district    => '1',
        subdistrict => 'X',
        sector      => undef,
        unit        => undef,
        partial     => 1,
    },
    'XX1X1' => {
        area        => 'XX',
        district    => '1',
        subdistrict => 'X',
        sector      => '1',
        unit        => undef,
        partial     => 1,
    },
    'XX11X1XX' => undef,

    # invalid according to letter restrictions
    'QI1 1AA' => {
        area        => 'QI',
        district    => '1',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA',
    },

    'AB10 1II' => {
        area          => 'AB',
        district      => '10',
        subdistrict   => undef,
        sector        => '1',
        unit          => 'II',
        valid_outcode => 1,
    },

    # technically valid, but outcode doesn't exist
    'A1 1AA' => {
        area        => 'A',
        district    => '1',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA',
        strict      => 1,
    },
    'A11 1AA' => {
        area        => 'A',
        district    => '11',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA',
        strict      => 1,
    },
    'AA1 1AA' => {
        area        => 'AA',
        district    => '1',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA',
        strict      => 1,
    },
    'AA11 1AA' => {
        area        => 'AA',
        district    => '11',
        subdistrict => undef,
        sector      => '1',
        unit        => 'AA',
        strict      => 1,
    },
    'A1A 1AA' => {
        area        => 'A',
        district    => '1',
        subdistrict => 'A',
        sector      => '1',
        unit        => 'AA',
        strict      => 1,
    },
    'AA1A 1AA' => {
        area        => 'AA',
        district    => '1',
        subdistrict => 'A',
        sector      => '1',
        unit        => 'AA',
        strict      => 1,
    },
    'AB10 1AA' => {
        area          => 'AB',
        district      => '10',
        subdistrict   => undef,
        sector        => '1',
        unit          => 'AA',
        strict        => 1,
        valid_outcode => 1,
    },
    'AB99 1AA' => {
        area             => 'AB',
        district         => '99',
        subdistrict      => undef,
        sector           => '1',
        unit             => 'AA',
        strict           => 1,
        valid_outcode    => 1,
        non_geographical => 1,
    },
    'BX99 1AA' => {
        area             => 'BX',
        district         => '99',
        subdistrict      => undef,
        sector           => '1',
        unit             => 'AA',
        strict           => 1,
        valid_outcode    => 1,
        non_geographical => 1,
    },
    'SE1' => {
        area          => 'SE',
        district      => '1',
        partial       => 1,
        subdistrict   => undef,
        sector        => undef,
        unit          => undef,
        strict        => 1,
        valid_outcode => 1,
        },
);

note "parse";

test_parse( \%tests );

note "parse - strict";

test_parse( \%tests, { strict => 1 } );

note "parse - valid";

test_parse( \%tests, { valid => 1 } );

note "parse - partial";

test_parse( \%tests, { partial => 1 } );

sub msg {
    my ( $pc, $expected ) = @_;
    return $expected ? "$pc parsed as expected" : "$pc invalid as expected";
}

sub test_parse {
    my ( $tests, $options ) = @_;

    $options ||= {};

    foreach my $pc ( sort keys %{$tests} ) {

        my $expected = clone $tests{$pc};

        if ($expected) {

            $expected->{valid_outcode} ||= 0;
            $expected->{partial}       ||= 0;
            $expected->{strict}        ||= 0;

            $expected = undef    #
                if $options->{strict}   && !$expected->{strict}
                or $options->{valid}    && !$expected->{valid_outcode}
                or !$options->{partial} && $expected->{partial};
        }

        my $parsed = $pkg->parse( $pc, $options );

        is_deeply $parsed, $expected, msg( $pc, $expected )
            or warn Dumper($parsed);

        # and try without space
        $pc =~ s/\s//;
        $parsed = $pkg->parse( $pc, $options );

        is_deeply $parsed, $expected, msg( $pc, $expected );
    }
}

done_testing();

