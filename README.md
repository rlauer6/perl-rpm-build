# Table of Contents

* [Background and Motivation](#background-and-motivation)
* [...More Background](#...more-background)
* [How It Works](#how-it-works)
* [Caveats and Notes](#caveats-and-notes)
* [Dependencies](#dependencies)
* [Recipes](#recipes)
  * [Create an RPM from a CPAN module](#create-an-rpm-from-a-cpan-module)
  * [Create an RPM for a Specific Version](#create-an-rpm-for-a-specific-version)
* [Acknowledgements](#acknowledgements)
* [License](#license)

2021-12-31

Project for creating RPMs from CPAN Perl modules.

# Background and Motivation

This project will help you create an RPM from a CPAN Perl module. If
you have been using Amazon Linux (1 or 2) you may have found that not
all CPAN modules have RPMs in their repos. Sometimes you won't find
them on EPEL or any other repo for that matter.  In any event, if you
can't find the RPM __and__ you have eschewed everyone's advice to
__never__ use the system Perl for application development, this might
help you out.

# ...More Background

Years ago there was a neat utility called `cpanspec` which attempted
to create an RPM spec file for you with proper build instructions
extracted from the CPAN distribution. Alas that has gone out of
support and bitrot has set in resulting in a utility that only works
*some* of the time with *some* becoming less and less as the bits
continue to rot.

You can still find it on [Sourceforge](cpanspec.sourceforge.net), so
give it a go first before trying this technique.

# How It Works

Admittedly, this is not going to work for everyone in all cases.  The
basic idea though is to simply use `cpanm` to build the module locally
and package only what the module provides.

# Caveats and Notes

1. The module will build all the dependencies for the module while
   packaging your module, but __will not package them__. This means that
   you will need to have all of the __build__ dependencies
   installed. I don't know what all of those might be for every module
   so __expect the build process to puke if you do not have those
   dependencies installed__. As a starter you may want to go ahead and
   install `gcc` now.
1. The build __does not__ run unit tests.
1. By default build will package the most recent version of the
   module. You can override that by providing your own `VERSION` file
   or provide a `VERSION` value to `make` (see Recipes below).
1. If you want to package multiple modules, run `make clean` between
   runs to remove the `VERSION` file created by `make`.
1. The assumption is you are packaging this for your application and
   man pages are not required. Therefore, by default the
   `--no-man-pages` option of `cpanm` is used. Hack the `.spec` file
   if you really need man pages.

# Dependencies

* `App::cpanminus`
* The `rpm-build` RPM
* GNU make

# Recipes

## Create an RPM from a CPAN module

```
make clean && make MODULE=Hash::Merge
```

## Create an RPM for a Specific Version

```
make clean && make MODULE=Amazon::Credentials VERSION=1.0.10
```

# Acknowledgements

Thanks to `App::cpanminus` author Tatshuiko Miyagawa for such a useful
and amazingly flexible tool!

# License

Do what you please. See [License](License)

