package Geo::UK::Postcode;

# ABSTRACT: Object and class methods for working with British postcodes.

# VERSION

use Moo;
use Geo::UK::Postcode::Regex;

=pod

=head1 SYNOPSIS

# TODO

=head1 DESCRIPTION

An attempt to make a useful package for dealing with UK Postcodes.

Currently in development - feedback welcome.

=cut


has raw => ( is => 'ro' );

has components => (
    is      => 'rwp',
    default => sub { {} },
);

around BUILDARGS => sub {
    my ( $orig, $class, $args ) = @_;

    unless ( ref $args ) {
        $args = { raw => $args };
    }

    return $class->$orig($args);
};

sub BUILD {
    my ($self) = @_;

    die "No raw postcode supplied" unless $self->raw;

    my $parsed = Geo::UK::Postcode::Regex->parse( uc $self->raw )
        or die sprintf "'%s' is not a valid postcode", $self->raw;

    $self->_set_components($parsed);
}

=head1 METHODS

=head2 area, district, subdistrict, sector, unit

Return the corresponding part of the postcde.

=cut

sub area        { shift->components->{area} }
sub district    { shift->components->{district} }
sub subdistrict { shift->components->{subdistrict} }
sub sector      { shift->components->{sector} }
sub unit        { shift->components->{unit} }

=head2 outcode

The first half of the postcode, before the space - comprises of the area and
district.

=head2 incode

The second half of the postcode, after the space - comprises of the sector
and unit.

=cut

sub outcode {
    sprintf( "%s%s%s",
        $_[0]->area, $_[0]->district, $_[0]->subdistrict || '' );
}

sub incode {
    $_[0]->sector . $_[0]->unit;
}

=head2 outward, inward

Aliases for C<outcode> and C<incode>.

=cut

sub outward { shift->outcode }
sub inward  { shift->incode }

=head2 fixed_format

Returns the full postcode in a fixed length (8 character) format, with extra
padding spaces inserted as necessary.

=cut

sub fixed_format { sprintf( "%*s %s", -4, $_[0]->outcode, $_[0]->incode ) }

=head1 CLASS METHODS

=head2 parse

=cut

sub parse { Geo::UK::Postcode::Regex->parse( @_[ 1, $#_ ] ) }

=head1 SEE ALSO

=over

=item Geo::Postcode

=item Data::Validation::Constraints::Postcode

=item CGI::Untaint::uk_postcode

=item Form::Validator::UKPostcode 

=back

=cut

1;

