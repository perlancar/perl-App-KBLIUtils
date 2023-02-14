package App::KBLIUtils;

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

my $res;

$res = gen_read_table_func(
    name => 'list_kbli_categories',
    summary => 'List KBLI categories',
    table_data => do { require TableData::Business::ID::KBLI::2020::Category; TableData::Business::ID::KBLI::2020::Category->new },
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;

$res = gen_read_table_func(
    name => 'list_kbli_codes',
    summary => 'List KBLI codes',
    table_data => do { require TableData::Business::ID::KBLI::2020::Code; TableData::Business::ID::KBLI::2020::Code->new },
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;

1;
#ABSTRACT: Utilities related to chemistry

=head1 DESCRIPTION

This distributions provides the following command-line utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

=cut
