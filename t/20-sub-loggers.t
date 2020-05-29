
use v6;

use Test;
use Log;

plan 2;

my ($ran-A, $ran-B);
my $log-A = Log::new('my-logger');
my $log-B = Log::new('other');
$log-B.add-subscriber: $log-A;
$log-A.add-subscriber: { $ran-A = True; };
$log-B.add-subscriber: { $ran-B = True; };

$log-B.INFO:  'An info msg';

ok($ran-A, "logger A reacts to a message from logger B");
ok($ran-B, "logger B reacts to a message from logger B");

done-testing;

