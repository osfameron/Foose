package List;
use Foose;

constructor 'Empty';
constructor Cons => (
    safeHead => Any,
    safeTail => class_type('List')
);

package main;
use Data::Dumper;

use Test::More;

my $list = List::Cons->new(
    safeHead => "foo",
    safeTail => List::Empty->new
);
is ($list->safeHead, 'foo');
diag Dumper($list);

my $list2 = $list->safeHead('bar');
is ($list2->safeHead, 'bar');
diag Dumper($list2);

done_testing;

# TODO: munge BUILD!
# my $list3 = List::Cons->new( [2, List::Empty->new ] ); 

1;
