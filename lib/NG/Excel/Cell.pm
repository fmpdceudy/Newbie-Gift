use 5.010;
use NG;
use NG::Hashtable;

def_class 'NG::Excel::Cell' => 'NG::Object' => ['valued', 'widthd', 'border_leftd', 'border_bottomd'] => {

    build => sub {
        my ( $self, $args ) = @_;
        my $config = new NG::Hashtable( $args );
        $self->valued = $config->get('value') || "";
        $self->widthd = $config->get('width') || 10;
        $self->border_leftd = $config->get('border_left') ||
                { width => 0, style => 'none', color => 0x0000ff };
        $self->border_bottomd = $config->get('border_bottom') ||
                { width => 0, style => 'none', color => 0x0000ff };
    },

    value => sub {
        my ( $self, $new_val ) = @_;
        if ( defined $new_val ) {
            $self->valued = $new_val;
            return $self;
        } else {
            return $self->valued;
        }
    },

    border_left => sub {
        my ( $self, $width, $style, $color ) = @_;
        if ( scalar(@_) > 1 ) {
            $self->border_leftd = { width => $width, style => $style, color => $color };
            return $self;
        } else {
            return new NG::Hashtable( $self->border_leftd );
        }
    },

    border_bottom => sub {
        my ( $self, $width, $style, $color ) = @_;
        if ( scalar(@_) > 1 ) {
            $self->border_bottomd = { width => $width, style => $style, color => $color };
            return $self;
        } else {
            return new NG::Hashtable( $self->border_bottomd );
        }
    },

    width => sub {
        my ( $self, $new_val ) = @_;
        if ( defined $new_val ) {
            $self->widthd = $new_val;
            return $self;
        } else {
            return $self->widthd;
        }
    },

    english_to_num => sub {
        my ( $class, $width, $style ) = @_;
        given ( lc $style ) {
            when ('solid') {
                given ($width) {
                    when (0) { return 7; }
                    when (1) { return 1; }
                    when (2) { return 2; }
                    when (3) { return 5; }
                    default  { return 7; }
                }
            }
            when ('dash') {
                given ($width) {
                    when (1) { return 3; }
                    when (2) { return 8; }
                    default  { return 3; }
                }
            }
            when ('dash dot') {
                given ($width) {
                    when (1) { return 9; }
                    when (2) { return 10; }
                    default  { return 9; }
                }
            }
            when ('dash dot dot') {
                given ($width) {
                    when (1) { return 11; }
                    when (2) { return 12; }
                    default  { return 11; }
                }
            }
            when ('dot') {
                return 4;
            }
            when ('slantdash dot') {
                return 13;
            }
            when('double'){
                return 6;
            }
            default { return 0; }    #none
        }
    },

    num_to_english => sub {
        my ( $class, $index) = @_;
        given($index){
            when(0){return ('none', 0);}
            when(1){return ('solid', 1);}
            when(2){return ('solid', 2);}
            when(3){return ('dash', 1);}
            when(4){return ('dot', 1);}
            when(5){return ('solid', 3);}
            when(6){return ('double', 3);}
            when(7){return ('solid', 0);}
            when(8){return ('dash', 2);}
            when(9){return ('dash dot', 1);}
            when(10){return ('dash dot', 2);}
            when(11){return ('dash dot dot', 1);}
            when(12){return ('dash dot dot', 2);}
            when(13){return ('slantdash dot', 2);}
            default {return ('none', 0);}
        }
    },
};
1;
