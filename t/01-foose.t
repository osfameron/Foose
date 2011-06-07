package List;
use Foose::ADT;

constructor Empty => ();
constructor Cons => (
    safeHead => Any,
    safeTail => class_type('List')
);

package main;
use Data::Dumper;

use Test::More;
use Test::Exception;

my $list = List::Cons->new({
    safeHead => "foo",
    safeTail => List::Empty->new
});
is ($list->safeHead, 'foo');

my $list2 = $list->safeHead('bar');
is ($list2->safeHead, 'bar', 'modified');
is ($list->safeHead,  'foo', 'original unchanged');

dies_ok {
    my $error = List->new();
} "Cannot instantiate base class";

done_testing;

# YOW. This should invoke ::PositionalBuilder
my $list3 = List::Cons->new( [2, List::Empty->new ] ); 

1;
