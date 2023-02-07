Name:           perl-Geo-H3-FFI
Version:        0.06
Release:        1%{?dist}
Summary:        Perl FFI binding to H3 library functions
License:        MIT
Group:          Development/Libraries
URL:            http://search.cpan.org/dist/Geo-H3-FFI/
Source0:        http://www.cpan.org/modules/by-module/Geo/Geo-H3-FFI-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch
BuildRequires:  perl(ExtUtils::MakeMaker)
BuildRequires:  perl(FFI::C)
BuildRequires:  perl(FFI::CheckLib)
BuildRequires:  perl(FFI::Platypus)
BuildRequires:  perl(Package::New)
BuildRequires:  perl(Test::More)
BuildRequires:  perl(Test::Number::Delta)
BuildRequires:  h3
Requires:       perl(FFI::C)
Requires:       perl(FFI::CheckLib)
Requires:       perl(FFI::Platypus)
Requires:       perl(Package::New)
Requires:       h3
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

%description
Perl FFI binding to H3 library functions

%prep
%setup -q -n Geo-H3-FFI-%{version}

%build
%{__perl} Makefile.PL INSTALLDIRS=vendor
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT

make pure_install PERL_INSTALL_ROOT=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -type f -name .packlist -exec rm -f {} \;
find $RPM_BUILD_ROOT -depth -type d -exec rmdir {} 2>/dev/null \;

%{_fixperms} $RPM_BUILD_ROOT/*

%check
make test

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc Changes META.json
%{perl_vendorlib}/*
%{_mandir}/man3/*

%changelog
* Mon Jun 14 2021 Michael R. Davis <mrdvt@cpan.org> 0.02-2
 - Specfile autogenerated by cpanspec 1.78.

* Tue May 18 2021 Michael R. Davis <mrdvt@cpan.org> 0.01-1
- Specfile autogenerated by cpanspec 1.78.
