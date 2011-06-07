package List;
use Foose::ADT;

constructor Empty => ();
constructor Cons => (
    safeHead => Any,
    safeTail => class_type('List')
);

package main;

use Test::More;
use Test::Exception;

my $list = List::Cons->new(
    safeHead => "foo",
    safeTail => List::Empty->new
);
is $list->safeHead, 'foo', 'simple test';

my $list2 = $list->safeHead('bar');
is $list2->safeHead, 'bar', 'modified';
is $list->safeHead,  'foo', 'original unchanged';

dies_ok {
    my $error = List->new();
} "Cannot instantiate base class";

my $list3 = List::Cons->new([ 'baz', List::Empty->new  ]); 
is $list3->safeHead, 'baz', 'Positional arguments work!';

done_testing;
