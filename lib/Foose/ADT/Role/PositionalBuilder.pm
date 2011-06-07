package Foose::ADT::Role::PositionalBuilder;

use Moose::Role;
use List::MoreUtils 'zip';

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;

    if (@_ == 1 and ref $_[0] and ref $_[0] eq 'HASH') {
        return $class->$orig(@_);
    }
    else {
        my @args = @_;
        my @attribute_names = 
            map $_->name,
            sort { $a->insertion_order <=> $b->insertion_order }
            $class->meta->get_all_attributes;

        # zip has a bloody prototype, so we have to avoid it with &zip if
        # we didn't have the intermediate array variables

        my %args = zip @attribute_names, @args;
        return $class->$orig(\%args);
    }
};

1;
