# sort.t

use Test::Most;

use List::Util qw/ shuffle /;
use Geo::UK::Postcode qw/ pc_sort /;

sub pc { Geo::UK::Postcode->new(shift) }

note 'as sort method with $a,$b';

my @pcs = map { pc($_) } ( 'AB10 1AA', 'AB10 1AB', 'AB10 2AA', 'AB11 1AA' );

my @unsorted = shuffle @pcs;

my @sorted = sort pc_sort @unsorted;

is_deeply [ map {"$_"} @sorted ], [ map {"$_"} @pcs ], "sorted correctly";

note "as method with arguments";

is pc_sort( pc("AB10 1AA"), pc("AB10 1AA") ), 0,  "match";
is pc_sort( pc("AB10 2AA"), pc("AB10 1AA") ), 1,  "gt";
is pc_sort( pc("AB10 1AA"), pc("AB10 2AA") ), -1, "lt";

done_testing();


