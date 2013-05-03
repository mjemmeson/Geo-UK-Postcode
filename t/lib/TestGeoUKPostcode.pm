package TestGeoUKPostcode;

use strict;
use warnings;

my @TEST_PCS = (
    {   raw          => 'AB1 2CD',
        area         => 'AB',
        district     => '1',
        subdistrict  => undef,
        sector       => '2',
        unit         => 'CD',
        outcode      => 'AB1',
        incode       => '2CD',
        fixed_format => 'AB1  2CD',
        valid        => 0,
    },
    {   raw          => 'WC1H 9EB',
        area         => 'WC',
        district     => '1',
        subdistrict  => 'H',
        sector       => '9',
        unit         => 'EB',
        outcode      => 'WC1H',
        incode       => '9EB',
        fixed_format => 'WC1H 9EB',
        valid        => 1,
    },
);

sub test_pcs {
    my ( $class, $args ) = @_;

    my @pcs = @TEST_PCS;

    foreach my $filter ( keys %{$args} ) {
        @pcs = grep { $_->{$filter} == $args->{$filter} } @pcs;
    }

    return @pcs;
}

sub get_format_list {
    my ( $class, $pc ) = @_;

    my @list;
    foreach ( $pc, lc $pc ) {
        push @list, $_;
        s/ /  /;
        push @list, $_;
        s/ //g;
        push @list, $_;
    }
    return @list;
}

1;

