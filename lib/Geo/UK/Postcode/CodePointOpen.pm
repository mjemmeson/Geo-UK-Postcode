package Geo::UK::Postcode::CodePointOpen;

use strict;
use warnings;

use Text::CSV;

=head1 NAME

Geo::UK::Postcode::CodePointOpen

=head1 SYNOPSIS

    use Geo::UK::Postcode::CodePointOpen;

    my $iterator = Geo::UK::Postcode::CodePointOpen->read( path => ... );

    while (my $pc = $iterator->()) {
        ...
    }

=head1 DESCRIPTION

=head1 METHODS

=head2 read

    my $iterator = Geo::UK::Postcode::CodePointOpen->read(
        path               => ...,  # path to Unzipped Code-Point Open directory
        short_column_names => 1,    # default is long
    );

Pass in the path containing the 'Doc' and 'Data' subdirectories.

Returns a coderef iterator. Call repeatedly to get a hashref of data for each
postcode in data files.

=cut

sub read {
    my ( $class, %args ) = @_;

    my $path = $args{path};
    die "Path missing or invalid" unless $path && -d $path;

    my $csv = Text::CSV->new( { binary => 1, eol => "\r\n" } )
        or die Text::CSV->error_diag();

    my $doc_dir  = "$path/Doc";
    my $data_dir = "$path/Data/CSV";

    # Get column headers
    my $headers_file = "$doc_dir/Code-Point_Open_Column_Headers.csv";
    open my $fh, '<', $headers_file or die "Can't open $headers_file: $!";

    my $short_col_names = $csv->getline($fh);
    my $long_col_names  = $csv->getline($fh);

    # Get list of data files
    opendir( my $dh, $data_dir ) or die "can't opendir $data_dir: $!";
    my @data_files = grep { /^[^.]/ && -f "$data_dir/$_" } readdir($dh);
    closedir $dh;
    @data_files = sort @data_files;

    # Create iterator coderef
    my $fh2;

    my $next_file = sub {
        my $file = shift @data_files or return;    # none left
        open( $fh2, '<', "$data_dir/$file" ) or die "Can't open $file: $!";
    };

    my $iterator = sub {

        $next_file->() unless ( $fh2 && !eof $fh2 );

        my $row = $csv->getline($fh2);

        my $i = 0;
        return {
            map { $_ => $row->[ $i++ ] } @{
                $args{short_column_names} ? $short_col_names : $long_col_names
            }
        };
    };

    return $iterator;
}

1;

