# parse.t

use Test::Most;

use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';

note "parse";

my %tests = (
    'X'       => undef,
    'XX1'     => undef,
    'XX11'    => undef,
    'XX1X'    => undef,
    'XX1X1'   => undef,
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

);

sub msg {
    my ( $pc, $expected ) = @_;
    return $expected ? "$pc parsed as expected" : "$pc invalid as expected";
}

foreach my $pc ( sort keys %tests ) {

    my $expected = $tests{$pc};
    my $parsed   = $pkg->parse($pc);

    is_deeply $parsed, $expected, msg( $pc, $expected );

    # and without space
    $pc =~ s/\s//;
    $parsed = $pkg->parse($pc);

    is_deeply $parsed, $expected, msg( $pc, $expected );

}

done_testing();

