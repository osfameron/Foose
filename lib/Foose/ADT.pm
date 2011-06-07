package Foose::ADT;

use Moose ();
require MooseX::ABC;
use Moose::Exporter;

use Moose::Util::TypeConstraints;
use MooseX::Types::Structured qw(Tuple);
use MooseX::Types::Moose      qw(ArrayRef Any);
use Data::UUID;

Moose::Exporter->setup_import_methods(
    with_meta => [qw/ constructor /],
    as_is     => [ qw/ Tuple ArrayRef Any /],

    # note, we have to export MooseX::ABC *first*, not sure why
    also      => [qw/
        MooseX::ABC
        Moose 
        Moose::Util::TypeConstraints
    /],
);

sub constructor {
    my ($meta, $name, @fields) = @_;

    my $parent_name = $meta->name;
    my $child_name  = join '::', $parent_name, $name;

    my $subclass = $meta->create(
        $child_name,
        superclasses => [ $parent_name ],
    );

    # for a pure FP module, using destructive array operations is SICK and WRONG
    # the programmer who wrote this will be punished, do not fear!

    my $ug = Data::UUID->new;
    while (@fields) {
        my ($name, $create_accessor);

        my $field = shift @fields;
        if (ref $field) {
            $name = "anon_" . $ug->create_str;
        }
        else {
            $name = $field;
            $field = shift @fields;
            $create_accessor++;
        }

        my $attribute = $meta->add_attribute( $name,
            is  => 'bare',
            isa => $field );

        if ($create_accessor) {
            my $method = $meta->add_method( $name => sub {
                my $self = shift;
                if (@_) {
                    return $meta->clone_object(
                        $self,
                        $attribute->name => shift,
                    );
                }
                else {
                    return $attribute->get_value( $self );
                }
            });
            $attribute->associate_method($method);
        }
    }
}

1;
