use strict;
use warnings;

use Excel;
my $new = new Excel;
$new->sheet(1)->name("afirst");
$new->sheet(1)->get(3,3)->value('ok');
$new->save("a.xls");

my $excel = new Excel("a.xls");
$excel->sheet(1)->name('ddddd');
my $cell = $excel->sheet(1)->get( 2, 'B' )->value('ok')->border_left(2, 'solid', 0xff0000);
$cell = $excel->sheet(1)->get(3, 'C')->border_bottom(2, 'double', 0xff0000)->width(100);
$cell->value("3c");
$excel->save("b.xls");
