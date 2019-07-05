package YCSB::Metrics;
#===============================================================================

=head1 NAME

YCSB::Metrics - YCSB metrics module


=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use YCSB::Metrics;

    my $m = YCSB::Metrics->new();

    # Loads metrics encoded in plain text
    $m->load_plain_text( $text );

    # Loads metrics encoded as JSON
    $m->load_json( $json );

    After metrics are loaded from a workload output, they 
    are available via the following attributes:

=over 4

=item overall_runtime_ms

=item overall_throughput_ops_sec 

=item total_gcs_g1_young_generation

=item total_gc_time_g1_young_generation

=item total_gc_time_percent_g1_young_generation 

=item total_gcs_g1_old_generation

=item total_gc_time_g1_old_generation_ms

=item total_gc_time_percent_g1_old_generation

=item total_gcs

=item total_gc_time_ms

=item total_gc_time_percent

=item cleanup_operations

=item cleanup_average_latency_us

=item cleanup_min_latency_us

=item cleanup_max_latency_us

=item cleanup_95th_percentile_latency_us

=item cleanup_99th_percentile_latency_us

=item insert_operations

=item insert_average_latency_us

=item insert_min_latency_us

=item insert_max_latency_us

=item insert_95th_percentile_latency_us

=item insert_99th_percentile_latency_us

=item insert_return_ok



=head1 EXPORT


=head1 AUTHOR

Marco Masetti, C<< <marco.masetti at softeco.it> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc YCSB::Metrics


=head1 LICENSE AND COPYRIGHT

Copyright 2015 Marco Masetti.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=head1 SUBROUTINES/METHODS

=cut

#===============================================================================
use Moose;
use JSON::XS;
use Try::Tiny;
use Log::Log4perl;

has 'OVERALL_RunTime_ms'                            => ( is => 'rw', isa => 'Int');
has 'OVERALL_Throughput_ops_sec'                    => ( is => 'rw', isa => 'Num' );
has 'TOTAL_GCS_G1_Young_Generation_Count'           => ( is => 'rw', isa => 'Int');
has 'TOTAL_GC_TIME_G1_Young_Generation_Time_ms'     => ( is => 'rw', isa => 'Int');
has 'TOTAL_GC_TIME_percent_G1_Young_Generation_Time_percent'  => ( is => 'rw', isa => 'Num' );
has 'TOTAL_GCS_G1_Old_Generation'                   => ( is => 'rw', isa => 'Int');
has 'TOTAL_GC_TIME_G1_Old_Generation_Time_ms'       => ( is => 'rw', isa => 'Int');
has 'TOTAL_GC_TIME_percent_G1_Old_Generation_Time_percent'    => ( is => 'rw', isa => 'Num' );
has 'TOTAL_GCs_Count'                               => ( is => 'rw', isa => 'Int');
has 'TOTAL_GC_TIME_Time_ms'                         => ( is => 'rw', isa => 'Int');
has 'TOTAL_GC_TIME_percent_Time_percent'            => ( is => 'rw', isa => 'Num' );
has 'CLEANUP_Operations'                            => ( is => 'rw', isa => 'Int');
has 'CLEANUP_AverageLatency_us'                     => ( is => 'rw', isa => 'Num' );
has 'CLEANUP_MinLatency_us'                         => ( is => 'rw', isa => 'Int' );
has 'CLEANUP_MaxLatency_us'                         => ( is => 'rw', isa => 'Int' );
has 'CLEANUP_95thPercentileLatency_us'              => ( is => 'rw', isa => 'Int' );
has 'CLEANUP_99thPercentileLatency_us'              => ( is => 'rw', isa => 'Int' );
has 'INSERT_Operations'                             => ( is => 'rw', isa => 'Int' );
has 'INSERT_AverageLatency_us'                      => ( is => 'rw', isa => 'Num' );
has 'INSERT_MinLatency_us'                          => ( is => 'rw', isa => 'Int' );
has 'INSERT_MaxLatency_us'                          => ( is => 'rw', isa => 'Int' );
has 'INSERT_95thPercentileLatency_us'               => ( is => 'rw', isa => 'Int' );
has 'INSERT_99thPercentileLatency_us'               => ( is => 'rw', isa => 'Int' );
has 'INSERT_Return_OK'                              => ( is => 'rw', isa => 'Int' );

has 'log' => (
    is => 'ro',
    isa => 'Log::Log4perl::Logger',
    lazy    => 1,
    default => sub { return Log::Log4perl->get_logger(__PACKAGE__) },
);

#=============================================================

=head2 load_plain_text

=head3 INPUT

=head3 OUTPUT

=head3 DESCRIPTION

Loads an output text that should conform to the following pattern:

[METRIC_TYPE], metric_and/or_uom, value


=cut

#=============================================================
sub load_plain_text {
    my ( $self, $text ) = @_;

    try {
        my @lines = split(/\n/, $text);
        foreach ( @lines ) {
            my ($metric, $measurement, $value) = split(/,/);
    
            $metric      = format_metric( $metric );
            $measurement = format_measurement( $measurement );
            $value =~ s/ //g;
    
            my $key = $metric.'_'.$measurement;
            $self->{ $key } = $value;
        }
        return 1;
    } catch {
        $self->log->error("Couldn't decode text: $_");
        return 0;
    };
}

sub load_json {
    my ( $self, $json ) = @_;

    try {
        my $h = decode_json ($json);

        foreach ( @$h ) {
            my $metric = format_metric( $_->{metric} );
            my $measurement = format_measurement( $_->{measurement} );
            my $value = $_->{value};
            $value =~ s/ //g;

            my $key = $metric.'_'.$measurement;
            $self->{ $key } = $value;
        }
        return 1;
    } catch {
        $self->log->error("Couldn't decode json text: $_");
        return 0;
    };
}

sub load_metrics {
    my ( $self, $text ) = @_;

    $self->load_json( $text ) || $self->load_plain_text( $text );
}

sub format_metric {
    my $metric = shift;
    die "No metric found!" unless $metric;

    $metric =~ s/\[//g;
    $metric =~ s/\]//g;
    $metric =~ s/%/percent/g;

    return $metric;
}

sub format_measurement {
    my $measurement = shift;
    die "No measurement found!" unless $measurement;

    $measurement =~ s/%/percent/g;
    $measurement =~ s/\(/_/g;
    $measurement =~ s/\)//g;
    $measurement =~ s|/|_|g;
    $measurement =~ s/=/_/g;
    $measurement =~ s/ //g;

    return $measurement;
}

1; 
 

