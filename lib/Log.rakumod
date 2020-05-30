
unit package Log:auth<littlebenlittle>:ver<0.0.0>;

my class message is Cool {
    has Str:D     $.source    is required;
    has Cool:D    $.message   is required;
    has Str:D     $.level     is required;
    has Instant:D $.timestamp is required;
}

class Logger {
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

        When subscriber is a Log::Logger, subscriber will be
        added a sub-logger to this logger. Any new log messages
        will be passed to all sub-loggers for this logger. )
    proto method add-subscriber($subscriber     -->Nil) {*}
    multi method add-subscriber(&subscriber     -->Nil) { $!supplier.Supply.act: &subscriber }
    multi method add-subscriber(Logger $logger  -->Nil) { $!supplier.Supply.act: { $logger.emit: $_ } }

    #| synonym for add-subscriber(Code)
    method subscribe($subscriber  -->Nil) { self.add-subscriber: $subscriber }
    
    proto method emit(*@args  -->Nil) {*}
    multi method emit(message $msg  -->Nil) { $!supplier.emit: $msg }
    multi method emit(Cool $message, Str $level  -->Nil) {
        self.emit: message.new(
            source    => $.name,
            message   => $message,
            level     => $level,
            timestamp => now,
        );
    }

    # TODO: littlebenlittle  2020-05-29T17:51:15Z
    #   maybe create these methods dynamically at compile time
    #   to support custom log and verbosity levels
    method DEBUG     (Cool:D $message -->Nil) { self.emit: $message, 'DEBUG'   ; }
    method INFO      (Cool:D $message -->Nil) { self.emit: $message, 'INFO'    ; }
    method WARN      (Cool:D $message -->Nil) { self.emit: $message, 'WARN'    ; }
    method ERROR     (Cool:D $message -->Nil) { self.emit: $message, 'ERROR'   ; }
    method CRITICAL  (Cool:D $message -->Nil) { self.emit: $message, 'CRITICAL'; }
}

our sub new(Str:D $logger-name -->Logger) {
    return Logger.new(name => $logger-name);
}

