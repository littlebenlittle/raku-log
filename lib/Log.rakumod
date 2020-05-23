
unit package Log:auth<littlebenlittle>:ver<0.0.0>;

my class message is Cool {
    has Str:D     $.source    is required;
    has Str:D     $.message   is required;
    has Str:D     $.level     is required;
    has Instant:D $.timestamp is required;
}

my class logger {
    has Str:D       $.name     is required;
    has Supplier:D  $!supplier is required;
    submethod BUILD (Str:D :$name) {
        $!name   = $name;
        $!supplier = Supplier.new;
    }
    # TODO: littlebenlittle 2020-05-23T12:17:02Z
    #   create these methods dynamically:
    method DEBUG(Str:D $message  -->Nil) {
        $!supplier.emit: message.new(
            source    => $.name,
            message   => $message,
            level     => 'DEBUG',
            timestamp => now,
        );
    }
    method INFO(Str:D $message  -->Nil) {
        $!supplier.emit: message.new(
            source    => $.name,
            message   => $message,
            level     => 'INFO',
            timestamp => now,
        );
    }
    method WARN(Str:D $message  -->Nil) {
        $!supplier.emit: message.new(
            source    => $.name,
            message   => $message,
            level     => 'WARN',
            timestamp => now,
        );
    }
    method ERROR(Str:D $message  -->Nil) {
        $!supplier.emit: message.new(
            source    => $.name,
            message   => $message,
            level     => 'ERROR',
            timestamp => now,
        );
    }
    method CRITICAL(Str:D $message  -->Nil) {
        $!supplier.emit: message.new(
            source    => $.name,
            message   => $message,
            level     => 'CRITICAL',
            timestamp => now,
        );
    }
    method subscribe(&callback  -->Nil) {
        my $supply = $!supplier.Supply.act: &callback;
    }
}

our sub new(Str:D $logger-name -->logger) {
    return logger.new(name => $logger-name);
}

