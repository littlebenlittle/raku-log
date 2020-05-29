
unit package Log:auth<littlebenlittle>:ver<0.0.0>;

my class message is Cool {
    has Str:D     $.source    is required;
    has Cool:D    $.message   is required;
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
    method subscribe(&callback  -->Nil) {
        $!supplier.Supply.act: &callback;
    }
    multi method add-subscriber(&callback  -->Nil) {
        $!supplier.Supply.act: &callback;
    }
    multi method add-subscriber(logger:D $logger  -->Nil) {
        my $supply = $!supplier.Supply.act: {
            $logger.emit: $_
        };
    }
    
    multi method emit(message:D $msg -->Nil) {
        $!supplier.emit: $msg;
    }

    multi method emit(Cool:D $message, Str:D $level  -->Nil) {
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

our sub new(Str:D $logger-name -->logger) {
    return logger.new(name => $logger-name);
}

