package Geo::UK::Postcode::CodePointUtils;

use strict;
use warnings;

use Text::CSV;

=head1 NAME

Geo::UK::Postcode::CodePointUtils

=head1 DESCRIPTION

Utils library for importing OS Code Point Open data

=cut

my $HEADER_FILE = '

my $csv;

sub _csv {
    $csv ||= Text::CSV->new();
    return $csv;
}

sub get_headers {
    
}






1;

