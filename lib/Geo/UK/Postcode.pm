package Geo::UK::Postcode;

# ABSTRACT: Object and class methods for working with British postcodes.

# VERSION

use Moo;
use MooX::Aliases;

use Geo::UK::Postcode::Regex;

use overload '""' => "as_string";

=pod

=head1 SYNOPSIS

# TODO

=head1 DESCRIPTION

An attempt to make a useful package for dealing with UK Postcodes.

Currently in development - feedback welcome.

See L<Geo::UK::Postcode::Regex> for more postcode parsing.

=cut

has raw           => ( is => 'ro' );                  # Str
has strict        => ( is => 'ro' );                  # Bool
has allow_partial => ( is => 'ro', default => 1 );    # Bool
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

    my $parsed = Geo::UK::Postcode::Regex->parse(
        uc $self->raw,
        {   strict  => $self->strict,
            partial => $self->allow_partial,
        }
    ) or die sprintf "Unable to parse '%s' as a postcode", $self->raw;

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
    ( $_[0]->sector // '' ) . ( $_[0]->unit || '' );
}

=head2 outward, inward

Aliases for C<outcode> and C<incode>.

=cut

alias outward => 'outcode';
alias inward  => 'incode';

=head2 fixed_format

    my $fixed_format = $postcode->fixed_format;

Returns the full postcode in a fixed length (8 character) format, with extra
padding spaces inserted as necessary.

=cut

# FIXME
sub fixed_format {
    sprintf( "%*s %*s", -4, -3, $_[0]->outcode, $_[0]->incode );
}

=head2 posttowns

    my (@posttowns) = $postcode->posttowns;

Returns list of one or more posttowns that this postcode is assigned to.

=cut

sub posttowns { Geo::UK::Postcode::Regex->posttowns( $_[0]->outcode ) }

=head2 is_valid

    unless ($postcode->is_valid) {
       print "$postcode does not have a valid outcode!";
    }

Returns true or false depending if the outcode is valid or not. Note that
the full postcode might still not exist.

=cut

sub is_valid {

    # FIXME
}

sub as_string { $_[0]->outcode . ' ' . $_[0]->incode }

# TODO sort function

=head1 SEE ALSO

=over

=item Geo::Address::Mail::UK

=item Geo::Postcode

=item Data::Validation::Constraints::Postcode

=item CGI::Untaint::uk_postcode

=item Form::Validator::UKPostcode 

=back

=head1 TODO

=over

=item Finalise API

=item Handle non-geographic postcodes

=item Handle British overseas territories

=item Handle special case postcodes, like GIR 0AA and SAN TA1

=back

=cut

1;

