#!/usr/bin/perl
use strict;
use warnings;
use FFI::CheckLib qw{};
my $check_lib = FFI::CheckLib::check_lib(lib => 'h3');
print "Check Lib: $check_lib\n";
