
# Log

Simple logging.

## Use

```raku
my $logger  = Log::new("my-logger");
$logger.subscribe: {
    note "[" ~ .timestamp.DateTime ~ "]" ~ " " ~ .source ~ " " ~ .level ~ ": " ~ .message;
};
$logger.DEBUG: 'a log message'; # ｢ ...? ｣
```

