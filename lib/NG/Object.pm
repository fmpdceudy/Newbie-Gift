use Data::Dumper qw(Dumper);
use NG;

def_class 'NG::Object' => undef => [] => {
    dump => sub {
        return Dumper(shift);
      }
};

1;
