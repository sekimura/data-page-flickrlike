package Data::Page::FlickrLike;

use warnings;
use strict;
use 5.008_001;

use Exporter::Lite;
use Data::Page;

our $VERSION = '1.00';

our @EXPORT = qw( navigations );

sub Data::Page::navigations {
    my ($self) = @_;
    my $nav;
    my $prev_skip = 1;
    my $next_skip = 1;
    for my $page ($self->first_page .. $self->last_page) {
        if ( (   $page > $self->current_page - 4
              && $page < $self->current_page + 4 ) ||
             ($self->current_page - 8 < $self->first_page
              && $page < $self->first_page + 7) ||
             ($self->last_page - 8    < $self->current_page
              && $page > $self->last_page  - 7) ||
             ($page < $self->first_page + 2) ||
             ($page > $self->last_page  - 2) ) {
            push @$nav, $page;
        }
        elsif ( ($page < $self->current_page && $prev_skip ) ) {
            push @$nav, 0;
            $prev_skip--;
        }
        elsif ( ($page > $self->current_page && $next_skip ) ) {
            push @$nav, 0;
            $next_skip--;
        }
    }
    return wantarray ? @$nav : $nav;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Data::Page::FlickrLike - Generates flickr-like navigation links

=head1 SYNOPSIS

    use Data::Page;
    use Data::Page::FlickrLike;

    my $page = Data::Page->new();
    $page->total_entries($total_entries);
    $page->entries_per_page($entries_per_page);
    $page->current_page($current_page);
   
    print join (" ",
            map { $_ == 0
              ? q{<span>...</span>}
              : qq{<a href="/page/$_">$_</a>}
            } $page->navigations);  

    # 1*2 3 4 5 6 7 ... 76 77
    # 1 2 ... 10 11 12 13*14 15 16 ... 76 77
    # 1 2 ... 71 72 73 74 75 76 77*
    # Note: * means the current page

=head1 DESCRIPTION

Data::Page::FlickrLike is an extension to Data::Page to generate flickr-like
navigation links.

=head1 METHODS 

=over 4

=item navigations (Data::Page)

This method gets an array reference consists of the number of pages.

   $nav = $page->navigations

It calculates: how may numbers should be displayed from the first page, how
many numbers should be displayed form the last page, whether or not there's 
a big enough gap between the first page and current page to put an ellipsis
and more.  As the name of this modules says, the array ref should make it 
easy to generate a "Flickr-Like" navigation.

It uses "0" for an ellipsis between two sets of page numbers.  For example, 
if you have enough amount of items, navigations() returns like this:

  [ 1, 2, 3, 4, 5, 6, 7, 0, 76, 77 ] 

So, you need to put an exception to display an ellipsis(...) like this.

    for my $num ($page->navigations) {
        if ($num == 0 ) {
            print "...";
        } else {
            print qq{<a href="/page/$_">$_</a>};
        }
    }

=back

=head1 AUTHOR

Masayoshi Sekimura E<lt>sekimura@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Data::Page>, L<Data::Page::Navigation>, http://flickr.com/

