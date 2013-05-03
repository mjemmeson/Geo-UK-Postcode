package Geo::UK::Postcode;

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

use Moo;

has raw => ( is => 'ro' );

has components => (
    is      => 'rwp',
    default => sub { {} },
);

# ABCDEFGHIJKLMNOPQRSTUVWXYZ
my $AREA1       = 'ABCDEFGHIJKLMNOPRSTUWYZ';    # [^QVX]
my $AREA2       = 'ABCDEFGHKLMNOPQRSTUVWXY';    # [^IJZ]
my $SUBDISTRICT = 'ABCDEFGHJKMNPRSTUVWXY';      # [^ILOQ]
my $UNIT        = 'ABDEFGHJLNPQRSTUWXYZ';       # [^CIKMOV]

my %REGEXES = (
    strict => {
        area     => qr/[$AREA1][$AREA2]/,
        district => qr/[1-9](?:[0-9]|[$SUBDISTRICT])?/,
        sector   => qr/[0-9]/,
        unit     => qr/[$UNIT]{2}/,
    },
    loose => {
        area     => qr/[A-Z]{1,2}/,
        district => qr/[1-9](?:[0-9]|[A-Z])?/,
        sector   => qr/[0-9]/,
        unit     => qr/[A-Z]{2}/,
    },
);

my $STRICT_REGEX = qr{
    ^
    ($REGEXES{strict}->{area})
    ($REGEXES{strict}->{district})
    \s*
    ($REGEXES{strict}->{sector})
    ($REGEXES{strict}->{unit})
    $
}x;

my $LOOSE_REGEX = qr{
    ^
    ($REGEXES{loose}->{area})
    ($REGEXES{loose}->{district})
    \s*
    ($REGEXES{loose}->{sector})
    ($REGEXES{loose}->{unit})
    $
}x;

=head1 CLASS METHODS

=head2 regex

=head2 loose_regex

=cut

sub regex       {$STRICT_REGEX}
sub loose_regex {$LOOSE_REGEX}

=head2 parse

    my $parsed = Geo::UK::Postcode->parse( "AA11 1AA" );

Returns hashref of the constituent parts.

TODO

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

=head1 SEE ALSO

=over

=item Geo::Postcode

=item Data::Validation::Constraints::Postcode

=item CGI::Untaint::uk_postcode

=item Form::Validator::UKPostcode 

=back

=cut

1;

