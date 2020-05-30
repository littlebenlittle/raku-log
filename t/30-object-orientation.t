
use v6;

use Test;
use Log;

plan 1;

lives-ok { Log::Logger.new(name => 'some-logger') }, 'create a logger from the Logger class';

done-testing;
