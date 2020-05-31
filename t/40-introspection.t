
use v6;

use Test;
use Log;

plan 5;

my $log = Log::new('test');
my $out;
$log.add-subscriber: {
    $out = "{sprintf '%6s', '[' ~ .level ~ ']'} {.file}: line {.line}\n{.message}";
};

$log.DEB: "message";
is $out, " [DEB] t/40-introspection.t: line {$?LINE - 1}\nmessage", "format debug message";

$log.INFO: "message";
is $out, "[INFO] t/40-introspection.t: line {$?LINE - 1}\nmessage", "format info message";

$log.WARN: "message";
is $out, "[WARN] t/40-introspection.t: line {$?LINE - 1}\nmessage", "format debug message";

$log.ERR: "message";
is $out, " [ERR] t/40-introspection.t: line {$?LINE - 1}\nmessage", "format info message";

$log.CRIT: "message";
is $out, "[CRIT] t/40-introspection.t: line {$?LINE - 1}\nmessage", "format info message";

done-testing;

