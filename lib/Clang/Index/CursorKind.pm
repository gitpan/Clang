package Clang::Index::CursorKind;
{
  $Clang::Index::CursorKind::VERSION = '0.02';
}

use strict;
use warnings;

=head1 NAME

Clang::Index::CursorKind - Clang cursor kind class

=head1 VERSION

version 0.02

=head1 DESCRIPTION

A C<Clang::Index::CursorKind> describes the kind of entity that a cursor refers
to.

=head1 METHODS

=head2 spelling( )

Retrieve the name of the given cursor kind.

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of Clang::Index::CursorKind
