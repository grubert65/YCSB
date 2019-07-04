package YCSB;
#============================================================= -*-perl-*-

=head1 NAME

YCSB - a simple module to handle YCSB workload output.

=head1 VERSION

This documentation refers to YCSB version 0.0.1

=cut

our $VERSION='0.0.1';


=head1 SYNOPSIS

    use YCSB qw( parse_output_file parse_output );

    # parses an output file, it should automatically detect
    # the format used (plain text/json)
    # Returns a YCSB::Metrics object
    my $metrics = parse_output_file( $file_path );

    # parses a workload output text
    # Returns a YCSB::Metrics object
    my $metrics = parse_output( $output_text );

    # ...or via proper object declaration...
    my $y = new YCSB;
    my $metrics = $y->parse_output_file( $file_path );


=head1 DESCRIPTION

A simple module...

=head1 AUTHOR

Marco Masetti (marco.masetti @ softeco.it )

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2015 Marco Masetti (marco.masetti at softeco.it). All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See perldoc perlartistic.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=head1 SUBROUTINES/METHODS

=cut

#========================================================================
use Moose;

1;

