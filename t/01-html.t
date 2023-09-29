#!perl
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Mock::HTTP::Tiny;
use JSON::PP;
use Data::Dumper;

use WWW::Crawl;

plan tests => 3;

$/ = undef;
open my $fh, '<', 't/mock_html.dat' or die "Can't open datafile";
my $replay = <$fh>;
close $fh;

$replay = eval { decode_json($replay) };

ok ( !$@, 'Parsed JSON' ) or BAIL_OUT($@);

is ( ref($replay), 'ARRAY', '$replay is an ARRAY ' );

die "Nothing to replay" unless $replay;

Test::Mock::HTTP::Tiny->set_mocked_data( $replay );

# diag ( Dumper (Test::Mock::HTTP::Tiny->mocked_data) );

my $crawl = WWW::Crawl->new(
    'timestamp' => 'a',
);

my @links = $crawl->crawl('https://www.testing.crawl/', \&link);

cmp_ok ( scalar @links, '==', 8, 'Correct link count');

sub link {
    diag ($_[0]);
}

