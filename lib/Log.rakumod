
unit package Log:auth<littlebenlittle>:ver<0.0.0>;

my class message is Cool {
    has Cool      $.source    is required;
    has Cool      $.message   is required;
    has Cool      $.level     is required;
    has Instant   $.timestamp is required;
    has Cool      $.file      is required;
    has Cool      $.line      is required;
}

class Log {
    has Str:D       $.name     is required;
    has Supplier:D  $!supplier is required;
    submethod BUILD (Str:D :$name) {
        $!name   = $name;
        $!supplier = Supplier.new;
    }
    #|( When subscriber is a callable, subscriber will be
        executed each time a log message is passed to this
        logger. The log message will be passed to subscriber.
        as the topic.

        When subscriber is a Log::Log, subscriber will be
        added a sub-logger to this logger. Any new log messages
        will be passed to all sub-loggers for this logger. )
    proto method add-subscriber($subscriber     -->Nil) {*}
    multi method add-subscriber(&subscriber     -->Nil) { $!supplier.Supply.act: &subscriber }
    multi method add-subscriber(Log $logger  -->Nil) { $!supplier.Supply.act: { $logger.emit: $_ } }

    #| synonym for add-subscriber(Code)
    method subscribe($subscriber  -->Nil) { self.add-subscriber: $subscriber }
    
    proto method emit(*@args  -->Nil) {*}
    multi method emit(message $msg  -->Nil) { $!supplier.emit: $msg }
    multi method emit(Cool $message, Str $level  -->Nil) {
        my $frame = callframe 2;
        self.emit: message.new(
            source    => $.name,
            message   => $message,
            level     => $level,
            timestamp => now,
            file      => $frame.file,
            line      => $frame.line,
        );
    }

    # TODO: littlebenlittle  2020-05-29T17:51:15Z
    #   maybe create these methods dynamically at compile time
    #   to support custom log and verbosity levels
    method DEB    (Cool:D $message -->Nil) { self.emit: $message, 'DEB'  }
    method INFO   (Cool:D $message -->Nil) { self.emit: $message, 'INFO' }
    method WARN   (Cool:D $message -->Nil) { self.emit: $message, 'WARN' }
    method ERR    (Cool:D $message -->Nil) { self.emit: $message, 'ERR'  }
    method CRIT   (Cool:D $message -->Nil) { self.emit: $message, 'CRIT' }
}

#|( contsructs a log with the given name.  the
    name of a log is NOT a unique identifier,
    so two log instances can both be named "foo" )
our sub new(Str:D $logger-name -->Log) {
    return Log.new(name => $logger-name);
}

role Logging[$name = fail "please provide a log name"] {
    has Log $.log = Log.new(name => $name);
}

