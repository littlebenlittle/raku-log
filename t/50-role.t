
use v6;

use Test;
use Log;

plan 1;

class A does Log::Logging['A'] {
    method f { self.log.INFO: 'test' }
}

my $a = A.new;
my $done = False;
say $a.^roles;
$a.log.subscribe: { $done = True };
$a.f;

ok $done, "logged a message through the Log::Logging role";

done-testing;

