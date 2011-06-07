package Foose::ADT::Role::PositionalBuilder;

use Moose::Role;

sub BUILD;
around BUILD => sub {
    my $orig = shift;
    my $self = shift;

    die "RARR!";

    if (!@_) {
        # no arg
    }
    elsif (@_ == 1 and ref $_[0] eq 'HASH') {
        # 1 arg hashref, usual Moose constructor, ignore
    }
    else {
        # this is a positional list, munge it!
        die "TODO";
    }
    return $self->$orig(@_);
};

1;
