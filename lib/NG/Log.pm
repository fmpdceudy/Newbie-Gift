use NG;
use NG::Array;

def_class 'NG::Log' => 'NG::Object' => [] => {

    process_log => sub {
        my ( $logfile, $cb, $sep ) = @_;
        $sep //= qr/\s+/;
        open my $log, '<', $logfile or return;
        while ( <$log> ) {
            chomp;
            $cb->( new NG::Array( split( $sep, $_ ) ) );
        }
        close $log;
    },

};

1;
