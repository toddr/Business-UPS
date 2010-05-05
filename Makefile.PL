use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'Business::UPS',
    'VERSION_FROM' => 'lib/Business/UPS.pm', # finds $VERSION
    'PREREQ_PM' => {
	'LWP::UserAgent' => 0,
    },
    'INSTALLDIRS' => 'site',
    'EXE_FILES' => [],
    'PL_FILES' => {},
    'dist' =>  {'COMPRESS'=>'gzip -9f', 'SUFFIX' => 'gz'}
);
