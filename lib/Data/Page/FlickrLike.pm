package Data::Page::FlickrLike;

use warnings;
use strict;
use 5.008_001;

use Exporter::Lite;
use Data::Page;

our $VERSION = '1.01';

our @EXPORT = qw( navigations );

our $InnerWindow = 3;
our $OuterWindow = 2;
our $MinLength   = 7;
our $GlueLength  = 2;

sub Data::Page::navigations {
    my ($self, $args) = @_;
    my $nav;
    my $prev_skip = 1;
    my $next_skip = 1;

    my $inner = exists $args->{inner_window}
      ? $args->{inner_window}
      : $Data::Page::FlickrLike::InnerWindow;
    my $outer = exists $args->{outer_window}
      ? $args->{outer_window}
      : $Data::Page::FlickrLike::OuterWindow;
    my $min = exists $args->{min_length}
      ? $args->{min_length}
      : $Data::Page::FlickrLike::MinLength;
    my $glue = exists $args->{glue_length}
      ? $args->{glue_length}
      : $Data::Page::FlickrLike::GlueLength;

    for my $page ($self->first_page .. $self->last_page) {
        if ((   $page >= $self->current_page - ($inner)
             && $page <= $self->current_page + ($inner)) ||
            ($self->current_page <= $self->first_page + ($inner + $glue + $outer)
             && $page < $self->first_page + $min ) ||
            ($self->current_page >= $self->last_page - ($inner + $glue + $outer)
             && $page > $self->last_page  - $min) ||
            ($page < $self->first_page + $outer) ||
            ($page > $self->last_page  - $outer)) {
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

=head1 CONFIGURATION VARIABLES

By default, navigation() generates an array reference to create pagination
links exactly as the same as Flickr.com does. But if you do not like this
behavior, you can tweak these configuration variables.

=over 4

=item $Data::Page::FlickrLike::InnerWindow or $page->navigations({inner_window => $val})

Customises the number of links displayed at side of the current page.

=item $Data::Page::FlickrLike::OuterWindow or $page->navigations({outer_window => $val}) 

Customises the number of links displayed at the start and end of the page
links.

=item $Data::Page::FlickrLike::MinLength or $page->navigations({min_length => $val})

Customises the minimum number of the links displayed when the current page at
the first or last page.

=item $Data::Page::FlickrLike::GlueLength or $page->navigations({glue_length => $val})

Customises the minimum number of the links at the either side of the current
page and the links at the first and last. For example, these "3g" and "4g"
are displayed because of the glue length (= 2).

 1   2   3   4   5   6*  7   8   9     ...   21   22
 1   2   3g  4   5   6   7*  8   9   10     ...   21   22
 1   2   3g  4g  5   6   7   8*  9   10   11     ...  21   22 
 1   2     ...   5   6   7   8   9*  10   11   12     ...   21   22

 (* means a number of the current page)

=back

=head1 AUTHOR

Masayoshi Sekimura E<lt>sekimura@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Data::Page>, L<Data::Page::Navigation>, http://flickr.com/

