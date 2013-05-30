use v5.10;
use NG;

def_class Array => Object => ['data'] => {

    build => sub {
        my ( $self, $args ) = @_;
        my @tmp = ();
        given ( ref $args ) {
            when ( 'ARRAY' ) {
                @tmp = ( @$args );
            }
            default {
                @tmp = ( $args );
            }
        };
        $self->data = \@tmp;
    },

    read => sub {
        my ( $class, $filepath ) =@_;
        open my $fh, '<', $filepath or return new Array;
        my $content = new Array;
        while ( <$fh> ) {
            chomp;
            $content->push( $_ );
        }
        close $fh;
        return $content;
    },

    each => sub {
        my ( $self, $sub ) = @_;
        for my $i ( 0 .. scalar( @{ $self->data } ) - 1 ) {
            $sub->( $self->data->[$i], $i );
        }
        return $self;
    },

    get => sub {
        my ( $self, $index ) = @_;
        return $self->data->[$index];
    },

    set => sub {
        my ( $self, $index, $val ) = @_;
        $self->data->[$index] = $val;
        return $self;
    },

    pop => sub {
        my ($self) = @_;
        return pop @{ $self->data };
    },

    push => sub {
        my ( $self, $value ) = @_;
        push @{ $self->data }, $value;
        return $self;
    },

    shift => sub {
        my ($self) = @_;
        return shift @{ $self->data };
    },

    unshift => sub {
        my ( $self, $value ) = @_;
        unshift @{ $self->data }, $value;
        return $self;
    },

    sort => sub {
        my ( $self, $sub ) = @_;
        my @tmp;
        if ( defined $sub ) {
            @tmp = sort { $sub->( $a, $b ) } @{ $self->data };
        } else {
            @tmp = sort @{ $self->data };
        }
        $self->data = \@tmp;
        return $self;
    },

    size => sub {
        my ($self) = @_;
        return scalar( @{ $self->data } );
    },
};

1;
