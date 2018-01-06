#!/usr/bin/perl

use strict;
use warnings;

use GD;

my $infile_name   = $ARGV[0];
my $matrix_width  = $ARGV[1] || 64;
my $matrix_height = $ARGV[2] || 32;
my $h_panels      = $ARGV[3] || 1;
my $v_panels      = $ARGV[4] || 2;

my @data;
my $rows        = int( $matrix_height / 2 );
my $full_width  = $matrix_width * $h_panels;
my $full_height = $matrix_height * $v_panels;

sub setPixel {
    my ( $x, $y, $r, $g, $b ) = @_;

    return if ( $x < 0 || $y < 0 || $x >= $full_width || $y >= $full_height );

    my $py = int( $y / $matrix_height );
    my $dy = $y % $matrix_height;

    my $addr = 4 * ( ( $x + ( $v_panels * ( $y % $rows ) + $py ) * $full_width ) * 2 + ( $dy >= $rows ? 1 : 0 ) );

    $data[ $addr + 0 ] = 0;
    $data[ $addr + 1 ] = $r;
    $data[ $addr + 2 ] = $g;
    $data[ $addr + 3 ] = $b;
}

sub mif {
    my $size = scalar(@data) / 8;

    print "-- matrix $matrix_width x $matrix_height leds\n";
    print "-- $h_panels x $v_panels panels\n";
    print "-- source file: $infile_name\n";

    print "WIDTH=64;\n";
    print "DEPTH=$size;\n";

    print "ADDRESS_RADIX=UNS;\n";
    print "DATA_RADIX=BIN;\n";
    print "CONTENT BEGIN\n";

    my $pvalue = undef;
    my ( $index, $jndex ) = ( 0, undef );

    for ( $index = 0 ; $index < $size ; $index++ ) {
        my $value = sprintf(
            "00000000%08b%08b%08b00000000%08b%08b%08b",
            $data[ $index * 8 + 1 ],
            $data[ $index * 8 + 2 ],
            $data[ $index * 8 + 3 ],
            $data[ $index * 8 + 5 ],
            $data[ $index * 8 + 6 ],
            $data[ $index * 8 + 7 ]
        );
        if ( !defined($pvalue) ) {
            $pvalue = $value;
            $jndex  = $index;
            next;
        }
        if ( $pvalue eq $value ) {
            next;
        }
        if ( $index - $jndex > 1 ) {
            print "\t[$jndex.." . ( $index - 1 ) . "]   :   $pvalue;\n";
        }
        else {
            print "\t$jndex   :   $pvalue;\n";
        }
        $pvalue = $value;
        $jndex  = $index;
    }

    if ( defined($pvalue) && $index != $jndex ) {
        if ( $index - $jndex > 1 ) {
            print "\t[$jndex.." . ( $index - 1 ) . "]   :   $pvalue;\n";
        }
        else {
            print "\t$jndex   :   $pvalue;\n";
        }
    }
    print "END;\n";
}

GD::Image->trueColor(1);
my $image = new GD::Image($infile_name) or die "Failed to open $infile_name: $!";
my ( $width, $height ) = $image->getBounds();

for ( my $x = 0 ; $x < $full_width ; $x++ ) {
    for ( my $y = 0 ; $y < $full_height ; $y++ ) {
        setPixel( $x, $y, 0, 0, 0 );
    }
}

my $wx = ( $full_width - $width ) / 2;
for ( my $x = 0 ; $x < $width ; $x++ ) {
    for ( my $y = 0 ; $y < $height ; $y++ ) {
        my $index = $image->getPixel( $x, $y );
        my ( $r, $g, $b ) = $image->rgb($index);
        setPixel( $wx + $x, $y, $r, $g, $b );
    }
}
$image = undef;

mif;
