#!/usr/bin/perl

use strict;
use warnings;

my $pwm_freq    = 256;
my $pwm_inp_max = 256;

for ( my $n = 0 ; $n < $pwm_inp_max ; $n++ ) {
    my $duty_high = int( ( $pwm_freq * $n ) / $pwm_inp_max );
    my $duty_low = $pwm_freq - $duty_high;

#    $duty_low-- if ($duty_low == 1);
#    $duty_high-- if ($duty_high == 1);

    my $acnum = ( $duty_low + 1 ) / ( $duty_high + 1 );

#    print "$duty_high $duty_low $acnum\n";

    my @a;
    my $ac = 0;

    while ($duty_high > 0 || $duty_low > 0) {
        $ac += $acnum;
        if ( $duty_low > 0 && $ac > 1.0 ) {
            while ( $duty_low > 0 && $ac > 1.0 ) {
                push @a, '0';
                $ac -= 1.0;
                $duty_low--;
            }
        }
        if ($duty_high > 0) {
            push @a, '1';
            $duty_high--;
        }
    }

    print "\`define r_lut[" . $n . "] 256'b" . join('', @a) . ";\n";
}
