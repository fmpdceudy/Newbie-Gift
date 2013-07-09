use NG;
use NG::Hashtable;
use Time::HiRes ();
use POSIX ();
def_class 'NG::Time' => 'NG::Object' => ['year', 'month', 'day', 'hour', 'minute', 'second', 'microsecond'] => {

    build => sub {
        my ( $self, $args ) = @_;
        my $tmp = NG::Hashtable->new($args);
        $self->year = $tmp->get('year') || 1970;
        $self->month = $tmp->get('month') || 1;
        $self->day = $tmp->get('day') || 1;
        $self->hour = $tmp->get('hour') || 0;
        $self->minute = $tmp->get('minute') || 0;
        $self->second = $tmp->get('second') || 0;
        $self->microsecond = 0 ;
    },

    now => sub {
        my @t = localtime;
        my $time = NG::Time->new(
            year => $t[5] + 1900,
            month => $t[4] + 1,
            day => $t[3],
            hour => $t[2],
            minute => $t[1],
            second => $t[0],
        );
        $time->microsecond = (Time::HiRes::gettimeofday)[1] ;
        $time;
    },

    tostr => sub {
        my ( $self, $format ) = @_;
        my @need_t;
        if ( ref( $self ) eq 'NG::Time' ) {
            @need_t = localtime( $self->to_epoch );
        } else {
            @need_t = localtime;
        }
        POSIX::strftime($format, @need_t);
    },

    to_epoch => sub {
        my ( $self ) = @_;
        POSIX::mktime(
            $self->second,
            $self->minute,
            $self->hour,
            $self->day,
            $self->month - 1,
            $self->year - 1900
        );
    },

    from_epoch => sub {
        my ( $self, $args) = @_;
        if ( ref( $self ) ne 'NG::Time' ) {
            $self = new NG::Time;
        }
        my @t = localtime( $args );
        $self->build(new NG::Hashtable(
            year => $t[5] + 1900,
            month => $t[4] + 1,
            day => $t[3],
            hour => $t[2],
            minute => $t[1],
            second => $t[0],
        ));
        $self;
    },

    to_float => sub {
        my ( $self ) = @_;
        if ( ref( $self ) eq 'Time' ) {
            return $self->to_epoch+$self->microsecond/1000000;
        } else {
            return Time::HiRes::time;
        }
    },

};

1;
