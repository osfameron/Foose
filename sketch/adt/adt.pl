use Data::Dumper;

package of;
use strict; use warnings;
use feature 'say';

sub AUTOLOAD {
    our $AUTOLOAD;
    
    # remove 'of'
    shift;
    my $constructor = ($AUTOLOAD =~ s/^of:://r);

    my $args = shift;
    my @args = $args ? @{$args->constructor} : ();

    my $type = Type->new(
        tag => $constructor,
        constructor => [ $constructor, @args ],
    );
}

package Type;
use Moo;
use Scalar::Util 'refaddr';

has constructor => (
    is => 'lazy',
    default => sub { [ $_[0]->tag ] },
);

has constructors => (
    is => 'lazy',
    default => sub { [ $_[0]->constructor ] },
);

has 'tag' => (
    is => 'lazy',
    default => '',
);

use overload '*' => \&product,
             '|' => \&sum,
             '""' => \&stringify;

sub product {
    my ($other, $self) = @_;
    my $constructor = [ $self, $other ];
    return $self->new(
        constructor => $constructor,
    );
};
sub sum {
    my ($other, $self) = @_;
    return $self->new(
        constructors => [ @{ $self->constructors }, @{ $other->constructors } ],
    );
};
sub stringify { $_[0]->tag . ' ' . refaddr $_[0] }

package main;
use strict; use warnings;
use Package::Stash;

sub type {

    my $name = shift;

    # any `my $a` etc. vars passed in get overwritten
    my @chars = ('a'..'z');
    for my $i (0..$#_) {
        $_[$i] = Type->new( tag => '$' . $chars[$i] );
    }

    my $type = Type->new( tag => $name );
    my $stash = Package::Stash->new(scalar caller);
    $stash->add_symbol("&${name}" => sub { $type });

}

sub define {
    say "Here is the data-structure for the ADT being defined:";
    say Data::Dumper::Dumper( \@_ );
}

{
type List => my $a;
define List => 
      of->Nil 
    | Cons of $a * List($a);
}
