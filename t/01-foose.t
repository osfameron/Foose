package List;
use Foose;
use Data::Dumper;
use feature 'say';

constructor 'Empty';
constructor Cons => (
    safeHead => Any,
    safeTail => class_type('List')
);

my $list = List::Cons->new(
    safeHead => "foo",
    safeTail => List::Empty->new
);
say Dumper($list);

my $list2 = $list->safeHead('bar');
say Dumper($list2);

# TODO: munge BUILD!
# my $list3 = List::Cons->new( [2, List::Empty->new ] ); 

1;
