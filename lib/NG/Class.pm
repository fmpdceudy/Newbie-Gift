package NG::Class;

sub def{
    my ($class, $parent, $attrs, $methods) = @_;

    eval "use $parent";

    #super class
    if($parent ne 'undef' ){
        *t = eval('*'.$class.'::ISA');
        @t = ($parent);
    }

    #methods
    for(keys %$methods){
        if(ref($methods->{$_}) eq 'CODE'){
            *t = eval('*'.$class.'::'.$_);
            *t = $methods->{$_};
        }
    }

    #accessors
    for(@$attrs){
        my $attr=$_;
        *t = eval('*'.$class.'::'.$attr);
        *t = sub :lvalue{
            my ($self) = shift;
            $self->{$attr};
        };
    }

    #constructor
    *t = eval('*'.$class.'::new');
    *t = sub {

        my $o;
        if($parent ne 'undef' ){
            $p_attrs = new $parent;
            $o = bless {(map {($_, undef)} @$attrs), %$p_attrs }, $class;
        }
        else{
            $o = bless {map {($_, undef)} @$attrs}, $class;
        }

        my ($class, @args) = @_;
        if(scalar(@args)==1){
            $args = $args[0];
        }
        else{
            $args = \@args;
        }
        if(defined $methods->{build}){
            $o->build($args);
        }
        $o;
    };

}


1;
