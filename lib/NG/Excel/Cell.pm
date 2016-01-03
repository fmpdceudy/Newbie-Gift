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
        $style = lc $style;
        my %dic = {
            'solid',( 7, \{
                    0, 7,
                    1, 1,
                    2, 2,
                    3, 5,
                } ),
            'dash', ( 3, \{
                    1, 3,
                    2, 8,
                } ),
            'dash dot', ( 9, \{
                    1, 9,
                    2, 10,
                } ),
            'dash dot dot', ( 11, \{
                    1, 11,
                    2, 12,
                } ),
            'dot', ( 4, \{} ),
            'slantdash', ( 13, \{} ),
            'double', ( 6, \{} ),
        };

        if( ! exists $dic{$style} ) { return 0; }

        my ( $def, $map ) = $dic{$style};
        if( ! exists $map{$width} ) {
            return $def;
        } else {
            return $map{$width};
        }
    },

    num_to_english => sub {
        my ( $class, $index) = @_;
        my %dic = {
            0, ('none', 0),
            1, ('solid', 1),
            2, ('solid', 2),
            3, ('dash', 1),
            4, ('dot', 1),
            5, ('solid', 3),
            6, ('double', 3),
            7, ('solid', 0),
            8, ('dash', 2),
            9, ('dash dot', 1),
            10, ('dash dot', 2),
            11, ('dash dot dot', 1),
            12, ('dash dot dot', 2),
            13, ('slantdash dot', 2),
        };
        if( ! exists $dic{$index} ) {
            return ('none', 0);
        } else {
            return $dic{$index};
        }
    },
};
1;
