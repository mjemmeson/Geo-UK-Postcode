package Geo::UK::Postcode::Regex;

use strict;
use warnings;

=head1 NAME

Geo::UK::Postcode::Regex - regular expressions for handling British postcodes

=head1 DESCRIPTION

=cut

# ABCDEFGHIJKLMNOPQRSTUVWXYZ
my $AREA1       = 'ABCDEFGHIJKLMNOPRSTUWYZ';    # [^QVX]
my $AREA2       = 'ABCDEFGHKLMNOPQRSTUVWXY';    # [^IJZ]
my $SUBDISTRICT = 'ABCDEFGHJKMNPRSTUVWXY';      # [^ILOQ]
my $UNIT1        = 'ABDEFGHJKSTUW'; # C?
my $UNIT2        = 'ABDEFGHJLNPQRSTUWXYZ';

my @AREAS = qw/
  AB AL
  B BA BB BD BH BL BN BR BS BT
  CA CB CF CH CM CO CR CT CV CW
  DA DD DE DG DH DL DN DT DY
  E EC EH EN EX
  FK FY
  G GL GU GY
  HA HD HG HP HR HS HU HX
  IG IP IV
  KA KT KW KY
  L LA LD LE LL LN LS LU
  M ME MK ML
  N NE NG NN NP NR NW
  OL OX
  PA PE PH PL PO PR
  RG RH RM
  S SA SE SG SK SL SM SN SO SP SR SS ST SW SY
  TA TD TF TN TQ TR TS TW
  UB
  W WA WC WD WF WN WR WS WV
  YO
  ZE
/;

my @AREAS_SINGLE_DIGIT = qw/ BR FY HA HD HG HR HS HX JE LD SM SR WC WN ZE /;
my @AREAS_DOUBLE_DIGIT = qw/ AB LL SO /;
 
my @AREAS_SUBDISTRICT_ONLY = qw/ EC1 EC2 EC3 EC4 SW1 W1 WC1 WC2 /;
my @AREAS_SUBDISTRICY_POSSIBLE = qw/ E1 /;

#    Areas with a district '0' (zero): BL, BS, CM, CR, FY, HA, PR, SL, SS (BS is the only area to have #both a district 0 and a district 10).
#    The following central London single-digit districts have been further divided by inserting a lette#r after the digit and before the space: EC1–EC4 (but not EC50), SW1, W1, WC1, WC2, and part of E1 (E1W#), N1 (N1C and N1P), NW1 (NW1W) and SE1 (SE1P).
#    Post code sectors use digits from 1 to 9 followed by 0 (the Royal Mail originally sorted sector 0 #after 9, treating it as the 10th not the 1st sector label).



my %REGEXES = (
    strict => {
        area     => qr/[$AREA1][$AREA2]/,
        district => qr/[0-9](?:[0-9]|[$SUBDISTRICT])?/,
        sector   => qr/[0-9]/,
        unit     => qr/[$UNIT1][$UNIT2]{2}/,
    },
    loose => {
        area     => qr/[A-Z]{1,2}/,
        district => qr/[0-9](?:[0-9]|[A-Z])?/,
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

=head1 METHODS

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

    my ( $area, $district, $sector, $unit ) = $string =~ $LOOSE_REGEX
        or return;

    my $subdistrict = $district =~ s/([A-Z])$// ? $1 : undef;

    return {
        area        => $area,
        district    => $district,
        subdistrict => $subdistrict,
        sector      => $sector,
        unit        => $unit,
    };
}

1;
