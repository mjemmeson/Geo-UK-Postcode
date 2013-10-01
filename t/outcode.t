# outcode.t

use Test::Most;

use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';

note "extract outcode";
is $pkg->outcode('AB10 1AA'), 'AB10', "full";
is $pkg->outcode('AB101AA'),  'AB10', "full - no space";
is $pkg->outcode('B1 1AA'),   'B1',   "full";
is $pkg->outcode('B1 1'),     'B1',   "sector";
is $pkg->outcode('B1'),       'B1',   "district";
is $pkg->outcode('WC1H 9EB'), 'WC1H', "with subdistrict";
is $pkg->outcode('WC1H9EB'),  'WC1H', "with subdistrict - no space";

note "full only";
is $pkg->outcode( 'AB10 1AA', { partial => 0 } ), 'AB10', "full";
ok !$pkg->outcode( 'AB10', { partial => 0 } ), 'partial fails';

note "valid only";
is $pkg->outcode( 'AB10 1AA', { valid => 1 } ), 'AB10', "valid";
ok !$pkg->outcode( 'AB1', { valid => 1 } ), 'invalid fails';

done_testing();

