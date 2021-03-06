# NAME

Business::UPS - A UPS Interface Module

# SYNOPSIS

    use Business::UPS;

    my ($shipping,$ups_zone,$error) = getUPS(qw/GNDCOM 23606 23607 50/);
    $error and die "ERROR: $error\n";
    print "Shipping is \$$shipping\n";
    print "UPS Zone is $ups_zone\n";

    %track = UPStrack("z10192ixj29j39");
    $track{error} and die "ERROR: $track{error}";

    # 'Delivered' or 'In-transit'
    print "This package is $track{Current Status}\n"; 

# DESCRIPTION

A way of sending four arguments to a module to get shipping charges 
that can be used in, say, a CGI.

# REQUIREMENTS

I've tried to keep this package to a minimum, so you'll need:

- Perl 5.003 or higher
- LWP::UserAgent Module

# ARGUMENTS for getUPS()

Call the subroutine with the following values:

    1. Product code (see product-codes.txt)
    2. Origin Zip Code
    3. Destination Zip Code
    4. Weight of Package

and optionally:

    5.  Country Code, (see country-codes.txt)
    6.  Rate Chart (drop-off, pick-up, etc - see below)
    6.  Length,
    7.  Width,
    8.  Height,
    9.  Oversized (defined if oversized), and
    10. COD (defined if C.O.D.)

1. Product Codes:

        1DM           Next Day Air Early AM
        1DML          Next Day Air Early AM Letter
        1DA           Next Day Air
        1DAL          Next Day Air Letter
        1DP           Next Day Air Saver
        1DPL          Next Day Air Saver Letter
        2DM           2nd Day Air A.M.
        2DA           2nd Day Air
        2DML          2nd Day Air A.M. Letter
        2DAL          2nd Day Air Letter
        3DS           3 Day Select
        GNDCOM        Ground Commercial
        GNDRES        Ground Residential
        XPR           Worldwide Express
        XDM           Worldwide Express Plus
        XPRL          Worldwide Express Letter
        XDML          Worldwide Express Plus Letter
        XPD           Worldwide Expedited

    In an HTML "option" input it might look like this:

        <OPTION VALUE="1DM">Next Day Air Early AM
        <OPTION VALUE="1DML">Next Day Air Early AM Letter
        <OPTION SELECTED VALUE="1DA">Next Day Air
        <OPTION VALUE="1DAL">Next Day Air Letter
        <OPTION VALUE="1DP">Next Day Air Saver
        <OPTION VALUE="1DPL">Next Day Air Saver Letter
        <OPTION VALUE="2DM">2nd Day Air A.M.
        <OPTION VALUE="2DA">2nd Day Air
        <OPTION VALUE="2DML">2nd Day Air A.M. Letter
        <OPTION VALUE="2DAL">2nd Day Air Letter
        <OPTION VALUE="3DS">3 Day Select
        <OPTION VALUE="GNDCOM">Ground Commercial
        <OPTION VALUE="GNDRES">Ground Residential

2. Origin Zip(tm) Code

    Origin Zip Code as a number or string (NOT +4 Format)

3. Destination Zip(tm) Code

    Destination Zip Code as a number or string (NOT +4 Format)

4. Weight

    Weight of the package in pounds

5. Country

    Defaults to US

6. Rate Chart

    How does the package get to UPS:

    Can be one of the following:

        Regular Daily Pickup
        On Call Air
        One Time Pickup
        Letter Center
        Customer Counter

# ARGUMENTS for UPStrack()

The tracking number.

    use Business::UPS;
    %t = UPStrack("1ZX29W290250xxxxxx");
    print "This package is $track{'Current Status'}\n";

# RETURN VALUES

- getUPS()

            The raw LWP::UserAgent get returns a list with the following values:

              ##  Desc              Typical Value
              --  ---------------   -------------
              0.  Name of server:   UPSOnLine3
              1.  Product code:     GNDCOM
              2.  Orig Postal:      23606
              3.  Country:          US
              4.  Dest Postal:      23607
              5.  Country:          US
              6.  Shipping Zone:    002
              7.  Weight (lbs):     50
              8.  Sub-total Cost:   7.75
              9.  Addt'l Chrgs:     0.00
              10. Total Cost:       7.75

- UPStrack()

    The hash that's returned is like the following:

        'Last Updated'        => 'Jun 10 2003 12:28 P.M.'
        'Shipped On'          => 'June 9, 2003'
        'Signed By'           => 'SIGNATURE'
        'Shipped To'          => 'LOS ANGELES,CA,US'
        'Scanning'            => HASH(0x146e0c) (more later...)
        'Activity Count'      => 5
        'Weight'              => '16.00 Lbs'
        'Current Status'      => 'Delivered'
        'Location'            => 'RESIDENTIAL'
        'Service Type'        => 'STANDARD'

    Notice the key 'Scanning' is a reference to a hash.
    (Which is a reference to another hash.)

    Scanning will contain a hash with keys 1 .. (Activity Count)
    Each of those values is another hash, holding a reference to
    an activity that's happened to an item.  (See example for
    details)

        %hash{Scanning}{1}{'location'} = 'MESQUITE,TX,US';
        %hash{Scanning}{1}{'date'} = 'Jun 10, 2003';
        %hash{Scanning}{1}{'time'} = '12:55 A.M.';
        %hash{Scanning}{1}{'activity'} = 'ARRIVAL SCAN';
        %hash{Scanning}{2}{'location'} = 'MESQUITE,TX,US';
        .
        .
        .
        %hash{Scanning}{x}{'activity'} = 'DELIVERED';

    NOTE: The items generally go in reverse chronological order.

# EXAMPLE

- getUPS()

    To retreive the shipping of a 'Ground Commercial' Package 
    weighing 25lbs. sent from 23001 to 24002 this package would 
    be called like this:

        #!/usr/local/bin/perl
        use Business::UPS;

        my ($shipping,$ups_zone,$error) = getUPS(qw/GNDCOM 23001 23002 25/);
        $error and die "ERROR: $error\n";
        print "Shipping is \$$shipping\n";
        print "UPS Zone is $ups_zone\n";

- UPStrack()

        #!/usr/local/bin/perl

        use Business::UPS;

        %t = UPStrack("z10192ixj29j39");
        $t{error} and die "ERROR: $t{error}";
              
        print "This package is $t{'Current Status'}\n"; # 'Delivered' or 
                                                        # 'In-transit'
        print "More info:\n";
        foreach $key (keys %t) {
          print "KEY: $key = $t{$key}\n";
        }

        %activities = %{$t{'Scanning'}};

        print "Package activity:\n";
        for (my $num = $t{'Activity Count'}; $num > 0; $num--)
        {
              print "-- ITEM $num --\n";
              foreach $newkey (keys %{$activities{$num}})
              {
                      print "$newkey: $activities{$num}{$newkey}\n";
              }
        }

# BUGS

Probably lots.  Contact me if you find them.

# AUTHOR

Justin Wheeler <upsmodule@datademons.com>

mailto:upsmodule@datademons.com

This software was originally written by Mark Solomon <mailto:msoloman@seva.net> (http://www.seva.net/~msolomon/)

NOTE: UPS is a registered trademark of United Parcel Service.  Due to UPS licensing, using this software is not
be endorsed by UPS, and may not be allowed.  Use at your own risk.

# SEE ALSO

perl(1).

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 253:

    &#x3d;back doesn't take any parameters, but you said =back 4
