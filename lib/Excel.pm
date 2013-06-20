use NG;
use Array;
use Spreadsheet::WriteExcel;
use Spreadsheet::ParseExcel;
use Excel::Cell;
use Excel::Sheet;

def_class Excel => Object => ['sheets'] =>{

    build => sub{
        my ( $self, $args ) = @_;
        $self->sheets = Array->new;
        if ( ref( $args ) ne 'ARRAY' ) {
            $self->open( $args );
        }
    },

    open => sub {
        my ( $self, $filepath ) = @_;
        my $parser   = Spreadsheet::ParseExcel->new();
        my $workbook = $parser->parse($filepath);
        if ( !defined $workbook ) {
            die $parser->error() . "\n";
        }
        for my $sheet ( $workbook->worksheets() ) {
            my ( $row_min, $row_max ) = $sheet->row_range();
            my ( $col_min, $col_max ) = $sheet->col_range();
            my $ng_sheet = Excel::Sheet->new(
                name      => $sheet->get_name(),
                row_count => $row_max + 1,
                col_count => $col_max + 1,
            );
            for my $row ( $row_min .. $row_max ) {
                for my $col ( $col_min .. $col_max ) {
                    my $cell = $sheet->get_cell( $row, $col );
                    next unless $cell;
                    my $ng_cell = Excel::Cell->new( value => $cell->value(), );
                    $ng_sheet->set( $row+1, $col+1, $ng_cell );
                }
            }
            $self->sheets->push( $ng_sheet );
        }
    },

    sheet => sub {
        my ( $self, $sheet_num ) = @_;
        if( ! defined $self->sheets->get( $sheet_num -1 ) ) {
            $self->sheets->set( $sheet_num - 1, new Excel::Sheet );
        }
        return $self->sheets->get( $sheet_num-1 );
    },

    save => sub {
        my ( $self, $to_file ) = @_;
        unlink $to_file if -e $to_file;
        my $workbook = Spreadsheet::WriteExcel->new($to_file);
        $self->sheets->each(
            sub {
                my ( $sheet, $i ) = @_;
                my $worksheet = $workbook->add_worksheet( $sheet->name );
                my @col_width = ();
                for my $col ( 1 .. $sheet->col_count ) {
                    for my $row ( 1 .. $sheet->row_count ) {
                        my $cell = $sheet->get( $row, $col );
                        if ($cell) {
                            if ( $cell->width > ($col_width[$col] or 0) ) {
                                $col_width[$col] = $cell->width;
                            }
                            my $value  = $cell->value;
                            my $format = $workbook->add_format();
                            $workbook->set_custom_color( 40, '#' . uc( sprintf( "%.6x", $cell->border_bottom->get("color") )));
                            $workbook->set_custom_color( 41, '#' . uc( sprintf( "%.6x", $cell->border_left->get("color"))));
                            $format->set_bottom(
                                Excel::Cell->english_to_num(
                                    $cell->border_bottom->get("width"),
                                    $cell->border_bottom->get("style")
                                )
                            );
                            $format->set_bottom_color(40);
                            $format->set_left(
                                Excel::Cell->english_to_num(
                                    $cell->border_left->get("width"),
                                    $cell->border_left->get("style")
                                )
                            );
                            $format->set_left_color(41);
                            $worksheet->write( $row - 1, $col - 1, $value,
                                $format );
                        }
                    }
                }
                for ( my $i = 1 ; $i <= scalar(@col_width) ; $i++ ) {
                    $worksheet->set_column( $i - 1, $i - 1, $col_width[$i] );
                }
            }
        );
    },
};

1;
