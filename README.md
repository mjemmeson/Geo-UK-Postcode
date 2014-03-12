# NAME

Geo::UK::Postcode - Object and class methods for working with British postcodes.

# SYNOPSIS

    # See Geo::UK::Postcode::Regex for parsing/matching postcodes

    use Geo::UK::Postcode;

    my $pc = Geo::UK::Postcode->new("wc1h9eb");

    $pc->raw;             # wc1h9eb - as entered
    $pc->as_string;       # WC1H 9EB - output in correct format
    "$pc";                # stringifies, same output as '->as_string'
    $pc->fixed_format;    # 8 characters, the incode always last three

    $pc->area;            # WC
    $pc->district;        # 1
    $pc->subdistrict;     # H
    $pc->sector;          # 9
    $pc->unit;            # EB

    $pc->outcode;         # WC1H
    $pc->incode;          # 9EB

    $pc->strict;          # true if matches strict regex
    $pc->valid;           # true if matches strict regex and has a valid outcode
    $pc->partial;         # true if postcode is for a district or sector only

    $pc->non_geographical;    # true if outcode is known to be
                              # non-geographical

    # Sort Postcode objects:
    use Geo::UK::Postcode qw/ pc_sort /;

    my @sorted_pcs = sort pc_sort @unsorted_pcs;

# DESCRIPTION

An object to represent a British postcode.

For matching and parsing postcodes in a non-OO manner (for form validation, for
example), see [Geo::UK::Postcode::Regex](https://metacpan.org/pod/Geo::UK::Postcode::Regex)

For geo-location (finding latitude and longitude) see
["GEO-LOCATING POSTCODES"](#geo-locating-postcodes).

Currently undef development - feedback welcome. Basic API unlikely to change
greatly, just more features/more postcodes supported - see ["TODO"](#todo) list.

# METHODS

## raw

Returns exact string that the object was constructed from.

## as\_string

    $pc->as_string;

    # or:

    "$pc";

Stringification of postcode object, returns postcode with a single space
between outcode and incode.

## fixed\_format

    my $fixed_format = $postcode->fixed_format;

Returns the full postcode in a fixed length (8 character) format, with extra
padding spaces inserted as necessary.

## area, district, subdistrict, sector, unit

Return the corresponding part of the postcode, undef if not present.

## outcode

The first half of the postcode, before the space - comprises of the area and
district.

## incode

The second half of the postcode, after the space - comprises of the sector
and unit. Returns an empty string if not present.

## outward, inward

Aliases for `outcode` and `incode`.

## valid

    if ($pc->valid) {
        ...
    }

Returns true if postcode has valid outcode and matches strict regex.

## partial

    if ($pc->partial) {
      ...
    }

Returns true if postcode is not a full postcode, either a postcode district
( e . g . AB10 )
or postcode sector (e.g. AB10 1).

## strict

    if ($pc->strict) {
      ...
    }

Returns true if postcode matches strict regex, meaning all characters are valid
( although postcode might not exist ) .

## non\_geographical

    if ($pc->non_geographical) {
      ...
    }

Returns true if the outcode is known to be non-geographical. Note that
geographical outcodes may have non-geographical postcodes within them.

(Non-geographical postcodes are used for PO Boxes, or organisations
receiving large amounts of post).

## bfpo

    if ($pc->bfpo) {
        ...
    }

Returns true if postcode is mapped to a BFPO number (British Forces Post
Office).

## posttowns

    my (@posttowns) = $postcode->posttowns;

Returns list of one or more posttowns that this postcode is assigned to.

# EXPORTABLE

## pc\_sort

    my @sorted_pcs = sort pc_sort @unsorted_pcs;

Exportable sort function, sorts postcode objects in a useful manner. The
sort is in the following order: area, district, subdistrict, sector, unit
(ascending alphabetical or numerical order as appropriate).

# GEO-LOCATING POSTCODES

Postcodes can be geolocated by obtaining the Ordnance Survey 'Code-Point' data
(or the free 'Code-Point Open' data).

For full details of using this class with Code-Point data, see:
[Geo::UK::Postcode::Manual::Geolocation](https://metacpan.org/pod/Geo::UK::Postcode::Manual::Geolocation).

# SEE ALSO

- [Geo::UK::Postcode::Regex](https://metacpan.org/pod/Geo::UK::Postcode::Regex)
- [Geo::Address::Mail::UK](https://metacpan.org/pod/Geo::Address::Mail::UK)
- [Geo::Postcode](https://metacpan.org/pod/Geo::Postcode)

# AUTHOR

Michael Jemmeson <mjemmeson@cpan.org>

# COPYRIGHT

Copyright 2014- Michael Jemmeson

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
