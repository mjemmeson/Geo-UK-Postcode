package Geo::UK::Postcode;

use Moo;

has raw => ( is => 'ro' );

has components => (
    is      => 'rwp',
    default => sub { {} },
);

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

# FIXME
#[ABDEFGHJLNPQRSTUWXYZ]

=head1 CLASS METHODS

=head2 parse

    my $parsed = Geo::UK::Postcode->parse( "AA11 1AA" );

Returns hashref of the constituent parts, parsed from a loosely valid postcode(
only the structure is 

=cut

sub parse {
    my ( $class, $string ) = @_;

    my ( $area, $district, $sector, $unit ) = $string =~ m{
        ^ 
          ([A-Z]{1,2})      # area
          ([1-9][0-9A-Z]?)  # district (+ subdistrict?)
          \s*
          ([0-9])           # sector
          ([A-Z]{2})        # unit
        $
    }x or return;

    my $subdistrict = $district =~ s{([A-Z])$}{} ? $1 : undef;

    return {
        area        => $area,
        district    => $district,
        subdistrict => $subdistrict,
        sector      => $sector,
        unit        => $unit,
    };
}

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

    my $parsed = $self->parse( uc $self->raw )
        or die sprintf "'%s' is not a valid postcode", $self->raw;

    $self->_set_components($parsed);
}

sub area        { shift->components->{area} }
sub district    { shift->components->{district} }
sub subdistrict { shift->components->{subdistrict} }
sub sector      { shift->components->{sector} }
sub unit        { shift->components->{unit} }

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

1;

