package List;
use Foose::ADT;
use List::Util 'reduce';

constructor Empty => ();
constructor Cons => (
    safeHead => Any,
    safeTail => class_type('List')
);

sub fromList {
    my ($class, @list) = @_;
    reduce { no warnings 'once';
        List::Cons->new([$b, $a]) 
        }
        List::Empty->new,
        reverse @list; # in absence of a foldr...
}

package Match;
use Foose::ADT;
use Moose::Util::TypeConstraints;

use constant TC => class_type('Moose::Meta::TypeConstraint');

constructor Match => ( tc    => TC );
constructor Bind  => ( name => Str, node  => class_type('Match') );
constructor Group => ( group => ArrayRef[ class_type('Match') ]);

package main;

use feature 'say';
use Data::Dumper; local $Data::Dumper::Maxdepth=2; local $Data::Dumper::Indent = 1;
use Test::More;
use Test::Exception;
use Moose::Util::TypeConstraints;

my $list = List->fromList(1..5);
is $list->safeHead, 1, 'sanity';

my $match = Match::Match->new([ class_type('List') ]);
my $match2 = Match::Bind->new([ 'foo', $match ]);
my $match3 = Match::Group->new([[ $match, $match2 ]]);
say Dumper($match3);


done_testing;
