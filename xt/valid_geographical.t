# valid_geographical.t

# development tests - run against full Code-Point postcode database

use Test::Most;

use Data::Dumper::Concise;
use File::Slurp qw/ read_file /;
use Geo::UK::Postcode::Regex;

my $pkg = 'Geo::UK::Postcode::Regex';

my $re       = $pkg->strict_regex;
my $loose_re = $pkg->regex;

my ( @failures, @strict_failures );

if ( my ($file) = @ARGV ) {
    my @pcs = read_file $file;

    foreach (@pcs) {
        chomp;
        s/\s+/ /;
        push @failures,        $_ unless /$loose_re/;
        push @strict_failures, $_ unless /$re/;
    }
}

ok( !@failures, "all geographical postcodes passed loose regex" )
    or warn Dumper( [ sort @failures ] );

ok( !@strict_failures, "all geographical postcodes passed strict regex" )
    or warn Dumper( [ sort @strict_failures ] );

done_testing();

