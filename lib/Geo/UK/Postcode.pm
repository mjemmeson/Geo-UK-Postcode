package Geo::UK::Postcode;

use Moo;
use Geo::UK::Postcode::Regex;

=pod

=head1 NAME

Geo::UK::Postcode - Object and class methods for working with British postcodes

=head1 SYNOPSIS

    # Class methods:

    # break postcode string into components
    my $parsed = Geo::UK::Postcode->parse( $pc_str ) or die "Invalid format";

    # check postcode string is valid postcode
    if (Geo::UK::Postcode->is_valid( $pc_str )) {
        ...
    }

    # Using as object:

    my $pc = Geo::UK::Postcode->new("AB1 2CD");
    $pc->area;        # AB
    $pc->district;    # 1
    $pc->sector;      # 2
    $pc->unit;        # CD
    $pc->outward;     # AB1
    $pc->inward;      # 2CD

=head1 DESCRIPTION

# FIXME
http://en.wikipedia.org/

=cut

has raw => ( is => 'ro' );

has components => (
    is      => 'rwp',
    default => sub { {} },
);

sub area        { shift->components->{area} }
sub district    { shift->components->{district} }
sub subdistrict { shift->components->{subdistrict} }
sub sector      { shift->components->{sector} }
sub unit        { shift->components->{unit} }

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

sub outcode {
    sprintf( "%s%s%s",
        $_[0]->area, $_[0]->district, $_[0]->subdistrict || '' );
}

sub incode {
    $_[0]->sector . $_[0]->unit;
}

sub outward { shift->outcode }
sub inward  { shift->incode }

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

