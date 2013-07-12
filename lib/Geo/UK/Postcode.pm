package Geo::UK::Postcode;

use Moo;
use MooX::Aliases;

use base 'Exporter';
use Geo::UK::Postcode::Regex;

use overload '""' => "as_string";

# ABSTRACT: Object and class methods for working with British postcodes.

# VERSION

our @EXPORT_OK = qw/ pc_sort /;

=pod

=head1 SYNOPSIS

  use Geo::UK::Postcode;
  
  my $pc = Geo::UK::Postcode->new( "wc1h9eb" );
  
  $pc->raw;            # wc1h9eb - as entered
  $pc->as_string;      # WC1H 9EB - output in correct format
  "$pc";               # stringifies, same output as '->as_string'
  $pc->fixed_format;   # 8 characters, the incode always last three
  
  $pc->area;           # WC
  $pc->district;       # 1
  $pc->subdistrict;    # H
  $pc->sector;         # 9
  $pc->unit;           # EB
  
  $pc->outcode;        # WC1H
  $pc->incode;         # 9EB
  
  $pc->strict;     # true if matches strict regex
  $pc->valid;      # true if matches strict regex and has a valid outcode
  $pc->partial;    # true if postcode is for a district or sector only

  $pc->non_geographical;    # true if outcode is known to be
                            # non-geographical

  # Sort Postcode objects:
  use Geo::UK::Postcode qw/ pc_sort /;
  
  my @sorted_pcs = sort pc_sort @unsorted_pcs;

=head1 DESCRIPTION

An attempt to make a useful package for dealing with UK Postcodes.

See L<Geo::UK::Postcode::Regex> for matching and parsing postcodes.

Currently in development - feedback welcome.

=cut

has raw => ( is => 'ro' );    # Str
has components => (
    is      => 'rwp',
    default => sub { {} },
);

=for Pod::Coverage BUILDARGS BUILD

=cut

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

    my $pc = uc $self->raw;

    my $parsed = Geo::UK::Postcode::Regex->parse( $pc, { partial => 1 } )
        or die sprintf "Unable to parse '%s' as a postcode", $self->raw ;

    $self->_set_components($parsed);
}

=head1 METHODS

=head2 raw

Returns exact string that object was constructed from.

=head2 as_string

  $pc->as_string;

  # or:

  "$pc";

Stringification of postcode object, returns postcode with a single space
between outcode and incode.

=cut

sub as_string { $_[0]->outcode . ' ' . $_[0]->incode }

=head2 fixed_format

    my $fixed_format = $postcode->fixed_format;

Returns the full postcode in a fixed length (8 character) format, with extra
padding spaces inserted as necessary.

=cut

sub fixed_format {
    sprintf( "%-4s %-3s", $_[0]->outcode, $_[0]->incode );
}

=head2 area, district, subdistrict, sector, unit

Return the corresponding part of the postcode, undef if not present.

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
and unit. Returns an empty string if not present.

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

=head2 valid

  if ($pc->valid) {
    ...
  }

Returns true if postcode has valid outcode and matches strict regex.

=head2 partial

  if ($pc->partial) {
    ...
  }

Returns true if postcode is not a full postcode, either a postcode district
( e . g . AB10 )
or postcode sector (e.g. AB10 1).

=head2 strict

  if ($pc->strict) {
    ...
  }

Returns true if postcode matches strict regex, meaning all characters are valid
( although postcode might not exist ) .

=cut

sub valid {
    $_[0]->components->{valid_outcode} && $_[0]->components->{strict} ? 1 : 0;
}

sub partial {
    $_[0]->components->{partial} ? 1 : 0;
}

sub strict {
    $_[0]->components->{strict} ? 1 : 0;
}

=head2 non_geographical

    if ($pc->non_geographical) {
      ...
    }

Returns true if the outcode is known to be non-geographical. Note that
geographical outcodes may have non-geographical postcodes within them.

(Non-geographical postcodes are used for PO Boxes, or organisations
receiving large amounts of post).

=cut

sub non_geographical {
    $_[0]->components->{non_geographical} ? 1 : 0;
}

=head2 posttowns

    my (@posttowns) = $postcode->posttowns;

Returns list of one or more posttowns that this postcode is assigned to.

=cut

sub posttowns { Geo::UK::Postcode::Regex->posttowns( $_[0]->outcode ) }

=head1 EXPORTABLE

=head2 pc_sort

    my @sorted_pcs = sort pc_sort @unsorted_pcs;

Exportable sort function, sorts postcode objects in a useful manner. The
sort is in the following order: area, district, subdistrict, sector, unit
(ascending alphabetical or numerical order as appropriate).

=cut

sub pc_sort($$) {
           $_[0]->area cmp $_[1]->area
        || $_[0]->district <=> $_[1]->district
        || ( $_[0]->subdistrict || '' ) cmp( $_[1]->subdistrict || '' )
        || ( $_[0]->incode || '' ) cmp( $_[1]->incode || '' );
}

=head1 SEE ALSO

=over

=item *

L<Geo::Address::Mail::UK>

=item *

L<Geo::Postcode>

=item *

L<Data::Validation::Constraints::Postcode>

=item *

L<CGI::Untaint::uk_postcode>

=item *

L<Form::Validator::UKPostcode>

=back

=head1 TODO

=over

=item Finalise API

=item Handle non-geographic postcodes

=item Handle British overseas territories

=item Handle special case postcodes, like GIR 0AA and SAN TA1

=item Find out which BX non-geographical districts are used.

=item handle BFPO

=item cleanup method to correct common errors

=back

=cut

1;

