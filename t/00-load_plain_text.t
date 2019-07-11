use strict;
use warnings;

use Test::More qw(no_plan);

BEGIN { use_ok("YCSB::Metrics") };

ok( my $m = YCSB::Metrics->new(), 'new' );
my $text = <<EOT;
[OVERALL], RunTime(ms), 128
[OVERALL], Throughput(ops/sec), 7812.5
[TOTAL_GCS_G1_Young_Generation], Count, 0
[TOTAL_GC_TIME_G1_Young_Generation], Time(ms), 0
[TOTAL_GC_TIME_%_G1_Young_Generation], Time(%), 0.0
[TOTAL_GCS_G1_Old_Generation], Count, 0
[TOTAL_GC_TIME_G1_Old_Generation], Time(ms), 0
[TOTAL_GC_TIME_%_G1_Old_Generation], Time(%), 0.0
[TOTAL_GCs], Count, 0
[TOTAL_GC_TIME], Time(ms), 0
[TOTAL_GC_TIME_%], Time(%), 0.0
[CLEANUP], Operations, 1
[CLEANUP], AverageLatency(us), 3.0
[CLEANUP], MinLatency(us), 3
[CLEANUP], MaxLatency(us), 3
[CLEANUP], 95thPercentileLatency(us), 3
[CLEANUP], 99thPercentileLatency(us), 3
[INSERT], Operations, 1000
[INSERT], AverageLatency(us), 80.319
[INSERT], MinLatency(us), 30
[INSERT], MaxLatency(us), 1425
[INSERT], 95thPercentileLatency(us), 201
[INSERT], 99thPercentileLatency(us), 402
[INSERT], Return=OK, 1000
EOT

ok( $m->load_plain_text( $text ), 'load_plain_text' );
is( $m->{metrics}->{INSERT_99thPercentileLatency_us}, 402, 'got right data back' );


done_testing();
