#!/usr/bin/perl
use strict;
use warnings;

# If we compile our code below the strict rule, the compiler will indicate that we must
# declare this variable explicitly with correct scope visibility.
my $color = "no-color";
print("Neh: " . $color . "\n");

{
  # `my`: keyword is a lexically scoped variable. The variable is local to the enclosing block.
  my $color = "dude";
  print("Neh #1: " . $color . "\n");
}

print("Neh: " . $color . "\n");

# `our`: global variable that are visible throughout our program or from external packages.
our $glob_color = "a black";
my $num = 12345;

# String interpolation only apply inside the double quotes string.
print("The total cost of $glob_color T-shirt is: $num\n");

# Current section: https://www.perltutorial.org/perl-numbers/
