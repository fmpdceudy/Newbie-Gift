use NG;
use NG::Array;
use NG::Hashtable;

def_class 'NG::Excel::Sheet' => 'NG::Object' => ['named', 'cells', 'row_count', 'col_count'] => {

    build => sub {
        my ( $self, $args ) = @_;
        my $config = new NG::Hashtable($args);
        $self->named = $config->get('name') || 'no name';
        $self->cells = $config->get('cells') || NG::Array->new;
        $self->row_count = $config->get('row_count') || 0;
        $self->col_count = $config->get('col_count') || 0;
    },

    name => sub {
        my ( $self, $new_val ) = @_;
        if ( defined $new_val ) {
            $self->named = $new_val;
            return $self;
        } else {
            return $self->named;
        }
    },

    set => sub {
        my ( $self, $row, $col, $cell ) = @_;
        if ( $col =~ /^[A-Za-z]+$/ ) {
            $col = _letter_to_num($col);
        }
        $self->row_count = $row if $row > $self->row_count;
        $self->col_count = $col if $col > $self->col_count;
        if ( ! $self->cells->get( $row-1 )) {
            $self->cells->set( $row-1, NG::Array->new);
        }
        $self->cells->get( $row-1 )->set( $col-1, $cell );
        $self;
    },

    get => sub {
        my ( $self, $row, $col ) = @_;
        if ( $col =~ /^[A-Za-z]+$/ ) {
            $col = _letter_to_num($col);
        }
        $self->row_count = $row if $row > $self->row_count;
        $self->col_count = $col if $col > $self->col_count;
        if ( ! $self->cells->get( $row-1 )) {
            $self->cells->set( $row-1, NG::Array->new);
        }
        if ( ! $self->cells->get( $row-1 )->get( $col-1 )) {
            $self->cells->get( $row-1 )->set( $col-1, new NG::Excel::Cell );
        }
        return $self->cells->get($row-1)->get($col-1);
    },
};

sub _letter_to_num {
    my $str     = shift;
    my $letters = NG::Array->new(split //, uc($str));
    my $res     = 0;
    for ( my $i = ( $letters->size ) - 1 ; $i >= 0 ; $i-- ) {
        $res +=
        ( ( ord( $letters->get($i) ) - ord('A') + 1 ) *
            ( 26**($letters->size - $i - 1 ) ) );
    }
    return $res;
}

1;
