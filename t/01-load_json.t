use strict;
use warnings;

use Test::More qw(no_plan);

BEGIN { use_ok("YCSB::Metrics") };

ok( my $m = YCSB::Metrics->new(), 'new' );
my $text = <<EOT;
[
{
  "metric" : "OVERALL",
  "measurement" : "RunTime(ms)",
  "value" : 388153
},{
  "metric" : "OVERALL",
  "measurement" : "Throughput(ops/sec)",
  "value" : 257.63036740666695
},{
  "metric" : "TOTAL_GCS_Copy",
  "measurement" : "Count",
  "value" : 48
},{
  "metric" : "TOTAL_GC_TIME_Copy",
  "measurement" : "Time(ms)",
  "value" : 264
},{
  "metric" : "TOTAL_GC_TIME_%_Copy",
  "measurement" : "Time(%)",
  "value" : 0.06801441699536008
},{
  "metric" : "TOTAL_GCS_MarkSweepCompact",
  "measurement" : "Count",
  "value" : 0
},{
  "metric" : "TOTAL_GC_TIME_MarkSweepCompact",
  "measurement" : "Time(ms)",
  "value" : 0
},{
  "metric" : "TOTAL_GC_TIME_%_MarkSweepCompact",
  "measurement" : "Time(%)",
  "value" : 0.0
},{
  "metric" : "TOTAL_GCs",
  "measurement" : "Count",
  "value" : 48
},{
  "metric" : "TOTAL_GC_TIME",
  "measurement" : "Time(ms)",
  "value" : 264
},{
  "metric" : "TOTAL_GC_TIME_%",
  "measurement" : "Time(%)",
  "value" : 0.06801441699536008
},{
  "metric" : "CLEANUP",
  "measurement" : "Operations",
  "value" : 1
},{
  "metric" : "CLEANUP",
  "measurement" : "AverageLatency(us)",
  "value" : 2235392.0
},{
  "metric" : "CLEANUP",
  "measurement" : "MinLatency(us)",
  "value" : 2234368
},{
  "metric" : "CLEANUP",
  "measurement" : "MaxLatency(us)",
  "value" : 2236415
},{
  "metric" : "CLEANUP",
  "measurement" : "95thPercentileLatency(us)",
  "value" : 2236415
},{
  "metric" : "CLEANUP",
  "measurement" : "99thPercentileLatency(us)",
  "value" : 2236415
},{
  "metric" : "INSERT",
  "measurement" : "Operations",
  "value" : 100000
},{
  "metric" : "INSERT",
  "measurement" : "AverageLatency(us)",
  "value" : 3830.16262
},{
  "metric" : "INSERT",
  "measurement" : "MinLatency(us)",
  "value" : 1377
},{
  "metric" : "INSERT",
  "measurement" : "MaxLatency(us)",
  "value" : 24264703
},{
  "metric" : "INSERT",
  "measurement" : "95thPercentileLatency(us)",
  "value" : 7091
},{
  "metric" : "INSERT",
  "measurement" : "99thPercentileLatency(us)",
  "value" : 27935
},{
  "metric" : "INSERT",
  "measurement" : "Return=OK",
  "value" : 100000
}
]
EOT

ok( $m->load_json( $text ), 'load_json' );
is( $m->{metrics}->{INSERT_99thPercentileLatency_us}, 27935, 'got right data back' );


done_testing();
