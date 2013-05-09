# posttown.t

use Test::Most;

use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';

my %tests = (
    AB10       => [qw/ ABERDEEN /],
    'AB10 1AA' => [qw/ ABERDEEN /],
    AL7        => [ 'WELWYN', 'WELWYN GARDEN CITY' ],
);

foreach my $pc ( sort keys %tests ) {

    is_deeply [ $pkg->posttowns($pc) ], $tests{$pc}, "posttowns for $pc ok";
}

done_testing();

