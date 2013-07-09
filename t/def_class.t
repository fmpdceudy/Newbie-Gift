use strict;
use warnings FATAL => 'all';
use Test::More;
use lib '../lib';

use NG;


def_class Animal=>undef=>['name']=>{
    run => sub{
        my $self = shift;
        print "a " . $self->name . " is running\n";
    }
};

def_class Dog=>Animal=>['type']=>{
    build => sub{
        my $self = shift;
        $self->name = 'dog';
    }
};


my $dog = new Dog;

$dog->run;
$dog->type="subtype";
$dog->run;

def_class Mul=>undef=>['data']=>{
    build => sub{
        my ($self,$args) = @_;
        $self->data=$args;
    }
};

my $mul1=new Mul("1");
ok($mul1->data == "1","first set");
my $mul2=$mul1->new("2");
ok($mul2->data == "2","second set");
ok($mul1->data == "1","check first set");

done_testing;
