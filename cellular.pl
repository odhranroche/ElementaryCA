#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor;

my %rule = (
     "000" => "0",
     "001" => "1",
     "010" => "0",
     "011" => "1",
     "100" => "1",
     "101" => "1",
     "110" => "1",
     "111" => "0"
);

# takes a length
# creates 0-array of size N
sub create_array{
    my @arr = (0) x $_[0];
    return @arr;
}

# takes binary 1-d array
# prints in coloured blocks
sub print_array{
    foreach (@_){
        if ($_ == 0){
            print colored(" ", "on_black");
        }else{
            print colored(" ", "on_white");
        }
    }
    printf("\n");
}

# takes an array index and an array
# 0 -> 1 and 1 -> 0
sub flip{
    my $n = $_[0]+1;
    if ($_[$n] == 0){
        $_[$n] = 1;
    }else{
        $_[$n] = 0;
    }
}

# takes an integer upto 255
# returns binary array of result
sub num2rule{
    my $str = unpack("B32", pack("N", shift));
    my $rule_binary = substr($str,-8);
    return split //, $rule_binary;
}

# takes length 8 binary array
# applies content to rule
sub set_rule{
    $rule{"111"} = $_[0];
    $rule{"110"} = $_[1];
    $rule{"101"} = $_[2];
    $rule{"100"} = $_[3];
    $rule{"011"} = $_[4];
    $rule{"010"} = $_[5];
    $rule{"001"} = $_[6];
    $rule{"000"} = $_[7];

    printf("Rule $_[0]$_[1]$_[2]$_[3]$_[4]$_[5]$_[6]$_[7]\n");
}

# takes a binary array
# applies rule and returns result
sub evolve{
    my @new_array = ();
    my $length = @_;
    foreach my $i (0..$length-1){
        if ($i == $length-1){ # final element of array
            my $rule_key = "$_[$i-1]$_[$i]$_[0]";
            push @new_array, $rule{$rule_key};
        }else{
            my $rule_key = "$_[$i-1]$_[$i]$_[$i+1]";
            push @new_array, $rule{$rule_key};
        }
    }

    return @new_array;
}

# rule, width, number of transformations
sub run{
    my $rule_number = $_[0];
    my $width = $_[1];
    my $transforms = $_[2];

    my @arr = create_array($width);
    my @new_rule = num2rule($rule_number);
    set_rule @new_rule;

    my $half = @arr / 2;
    flip($half-1, @arr);

    for(1..$transforms){
        print_array @arr;
        @arr = evolve @arr;
    }
}

run($ARGV[0], 32, 16);
