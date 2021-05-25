use ExtUtils::MakeMaker;
WriteMakefile(
    NAME           => 'Geo::H3::FFI',
    VERSION_FROM   => 'lib/Geo/H3/FFI.pm',
    PREREQ_PM      => {
                       'Package::New'  => 0, 
                       'FFI::CheckLib' => 0, 
                       'FFI::Platypus' => 0, 
                       'FFI::C'        => 0, 
                      },
    ABSTRACT_FROM  => 'lib/Geo/H3/FFI.pm',
    AUTHOR         => 'Michael R. Davis (mrdvt@cpan.org)',
);
