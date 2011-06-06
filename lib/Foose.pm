package Foose;

use Moose ();
use Moose::Exporter;

use Moose::Util::TypeConstraints;
use MooseX::Types::Structured qw(Tuple);
use MooseX::Types::Moose      qw(ArrayRef Any);
use Data::UUID;

Moose::Exporter->setup_import_methods(
    with_meta => [qw/ constructor /],
    as_is     => [ qw/ Tuple ArrayRef Any /],
    also      => [qw/
        Moose Moose::Util::TypeConstraints
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
                    return $self->new({
                        %$self,
                        $attribute->name => shift,
                    });
                }
                else {
                    return $attribute->get_value( $self->meta );
                }
            });
            $attribute->associate_method($method);
        }
    }
}

1;
