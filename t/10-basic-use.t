use v6;

use Test;
use Log;

plan 5;

my $logger  = Log::new("my-logger");
my $last-source   = '';
my $last-message  = '';
my $last-level    = '';
my $last-ts       = '';
$logger.subscribe: {
    $last-source   = .source;
    $last-message  = .message;
    $last-level    = .level;
    $last-ts       = .timestamp;
};

for « DEBUG INFO WARN ERROR CRITICAL» -> $level {
    subtest "emit $level message" => {
        plan 4;
        # Call each method that exactly matches $level
        $logger.$_: 'a message' for $logger.^methods.grep( { $_.gist ~~ $level } );
        is $last-source     , 'my-logger'  , 'got expected source';
        is $last-message    , 'a message'  , 'got expected message';
        is $last-level      , $level       , 'got expected level';
        is-approx $last-ts  , now  , 0.1  , 'timestamp is recent';
    }
}

done-testing;

