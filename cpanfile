# kind of duplicate of Makefile.PL
#	but convenient for Continuous Integration
requires 'LWP::UserAgent' => 0;


on 'test' => sub {
    requires 'Test::More'     => 0;
};
