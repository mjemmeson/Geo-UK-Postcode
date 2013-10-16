# parse.t

use Test::Most;

use lib 't/lib';
use TestGeoUKPostcode;

use Data::Dumper::Concise;
use Clone qw/ clone /;
use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';


note "parse";
test_parse();

note "parse - strict";
test_parse( { strict => 1 } );

note "parse - valid";
test_parse( { valid => 1 } );

note "parse - partial";
test_parse( { partial => 1 } );

note "combinations - strict and valid";
test_parse( { strict => 1, valid => 1 } );

note "combinations - strict and partial";
test_parse( { strict => 1, partial => 1 } );

note "combinations - valid and partial";
test_parse( { valid => 1, partial => 1 } );


sub msg {
    my ( $pc, $expected ) = @_;
    return $expected->{area} ? "$pc parsed as expected" : "$pc invalid as expected";
}

sub test_parse {
    my ( $tests, $options ) = @_;

    $options ||= {};

    foreach my $pc ( TestGeoUKPostcode->test_pcs($options) ) {

        my @raw_list = TestGeoUKPostcode->get_format_list($pc);

        foreach my $raw (@raw_list) {

            my $expected = clone $pc;

            delete $expected->{raw};
            delete $expected->{fixed_format};

            if ( $expected->{area} ) {
                $expected->{outcode} = sprintf( "%s%s%s",
                    $expected->{area}, $expected->{district},
                    $expected->{subdistrict} || '' );

                $expected->{incode} = sprintf( "%s%s",
                    $expected->{sector} || '',
                    $expected->{unit}   || '' );

                $expected->{valid_outcode} ||= 0;
                $expected->{partial}       ||= 0;
                $expected->{strict}        ||= 0;
            }

            $expected = undef    #
                if !$expected->{area}
                || ( $options->{strict} && !$expected->{strict}
                or $options->{valid} && !$expected->{valid_outcode}
                or !$options->{partial} && $expected->{partial} );

            my $parsed = $pkg->parse( $raw, $options );

            is_deeply $parsed, $expected, msg( $raw, $expected )
                or die Dumper(
                { parsed => $parsed, raw => $raw, expected => $expected } );

        }
    }
}

done_testing();

