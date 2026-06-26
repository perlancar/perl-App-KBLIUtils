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
    name => 'list_kbli_2020_codes',
    summary => 'List KBLI 2020 codes',
    table_data => do { require TableData::Business::ID::KBLI::2020::Code; TableData::Business::ID::KBLI::2020::Code->new },
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;


$res = gen_read_table_func(
    name => 'list_kbli_2025_codes',
    summary => 'List KBLI 2025 codes',
    table_data => do { require TableData::Business::ID::KBLI::2025::Code; TableData::Business::ID::KBLI::2025::Code->new },
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;

$SPEC{compare_kbli_2020_2025_codes} = {
    v => 1.1,
    summary => 'Compare codes in KBLI 2020 vs 2025',
    args => {
        codes => {
            schema => ['array*', of=>'str*', min_len=>1],
            req => 1,
            pos => 0,
            slurpy => 1,
        },
    },
};
sub compare_kbli_2020_2025_codes {
    my %args = @_;
    my $codes = $args{codes}; $codes && @$codes or return [400, "Please specify one or more codes"];

    my $td_2020 = do { require TableData::Business::ID::KBLI::2020::Code; TableData::Business::ID::KBLI::2020::Code->new };
    my $td_2025 = do { require TableData::Business::ID::KBLI::2025::Code; TableData::Business::ID::KBLI::2025::Code->new };

    my $res = [200, "OK", [], {"table.fields"=>[qw/code status title_2020 title_2025 description_2020 description_2025/]}];

    my %rows_in_2020;
    my %rows_in_2025;
    $td_2020->each_item(sub { my ($row, $table, $index) = @_; if (grep { $_ == $row->[0] } @$codes) { $rows_in_2020{$row->[0]} = $row }; 1 });
    $td_2025->each_item(sub { my ($row, $table, $index) = @_; if (grep { $_ == $row->[0] } @$codes) { $rows_in_2025{$row->[0]} = $row }; 1 });

    #use DD; dd \%rows_in_2020; dd \%rows_in_2025;

    for my $code (@$codes) {
        my $row = {code => $code};
        if    (!$rows_in_2020{$code} && !$rows_in_2025{$code}) { $row->{status} = "UNKNOWN" }
        elsif ( $rows_in_2020{$code} &&  $rows_in_2025{$code}) { $row->{status} = "both exists" }
        elsif (!$rows_in_2020{$code} &&  $rows_in_2025{$code}) { $row->{status} = "NEW IN 2025" }
        elsif ( $rows_in_2020{$code} && !$rows_in_2025{$code}) { $row->{status} = "DELETED IN 2025" }

        if ($rows_in_2020{$code}) { $row->{title_2020} = $rows_in_2020{$code}[1]; $row->{description_2020} = $rows_in_2020{$code}[2] }
        if ($rows_in_2025{$code}) { $row->{title_2025} = $rows_in_2025{$code}[1]; $row->{description_2025} = $rows_in_2025{$code}[2] }

        push @{$res->[2]}, $row;
    }

    $res;
}

$SPEC{get_kbli_2020_title} = {
    v => 1.1,
    summary => 'Get title for a KBLI 2020 code',
    args => {
        code => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
};
sub get_kbli_2020_title {
    my %args = @_;
    my $code = $args{code}; $code or return [400, "Please specify one or more codes"];

    my $td = do { require TableData::Business::ID::KBLI::2020::Code; TableData::Business::ID::KBLI::2020::Code->new };

    my $title;
    $td->each_item(sub { my ($row, $table, $index) = @_; if ($code == $row->[0]) { $title = $row->[1]; 0 } else { 1 } });
    if ($title) { [200, "OK", $title] } else { [404, "Code not found"] }
}

$SPEC{get_kbli_2020_description} = {
    v => 1.1,
    summary => 'Get description for a KBLI 2020 code',
    args => {
        code => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
};
sub get_kbli_2020_description {
    my %args = @_;
    my $code = $args{code}; $code or return [400, "Please specify one or more codes"];

    my $td = do { require TableData::Business::ID::KBLI::2020::Code; TableData::Business::ID::KBLI::2020::Code->new };

    my $description;
    $td->each_item(sub { my ($row, $table, $index) = @_; if ($code == $row->[0]) { $description = $row->[2]; 0 } else { 1 } });
    if ($description) { [200, "OK", $description] } else { [404, "Code not found"] }
}

$SPEC{get_kbli_2025_title} = {
    v => 1.1,
    summary => 'Get title for a KBLI 2025 code',
    args => {
        code => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
};
sub get_kbli_2025_title {
    my %args = @_;
    my $code = $args{code}; $code or return [400, "Please specify one or more codes"];

    my $td = do { require TableData::Business::ID::KBLI::2025::Code; TableData::Business::ID::KBLI::2025::Code->new };

    my $title;
    $td->each_item(sub { my ($row, $table, $index) = @_; if ($code == $row->[0]) { $title = $row->[1]; 0 } else { 1 } });
    if ($title) { [200, "OK", $title] } else { [404, "Code not found"] }
}

$SPEC{get_kbli_2025_description} = {
    v => 1.1,
    summary => 'Get description for a KBLI 2025 code',
    args => {
        code => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
};
sub get_kbli_2025_description {
    my %args = @_;
    my $code = $args{code}; $code or return [400, "Please specify one or more codes"];

    my $td = do { require TableData::Business::ID::KBLI::2025::Code; TableData::Business::ID::KBLI::2025::Code->new };

    my $description;
    $td->each_item(sub { my ($row, $table, $index) = @_; if ($code == $row->[0]) { $description = $row->[2]; 0 } else { 1 } });
    if ($description) { [200, "OK", $description] } else { [404, "Code not found"] }
}

1;
#ABSTRACT: Utilities related to Indonesian KBLI ("Klasifikasi Baku Lapangan Usaha Indonesia" a.k.a. the Indonesian ISIC "International Standard Industrial Classification of All Economic Activities")

=head1 DESCRIPTION

This distributions provides the following command-line utilities:

# INSERT_EXECS_LIST

Keywords: KBLI, Klasifikasi Baku Lapangan Usaha Indonesia, ISIC, International Standard Industrial Classification of All Economic Activities


=head1 SEE ALSO

=cut
