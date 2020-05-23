
# Log

Simple logging.

## Use

```raku
my $logger  = Log::new("my-logger");
$logger.subscribe: {
    note "[" ~ .timestamp.DateTime ~ "]" ~ " " ~ .source ~ " " ~ .level ~ ": " ~ .message;
};
$logger.DEBUG: 'a log message'; # ｢ [2020-05-23T18:46:22.732551Z] my-logger DEBUG: a log message ｣
```

