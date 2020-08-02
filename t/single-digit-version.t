use strict;
use warnings;
use Test::More tests => 4*3*4;
use Test::Needs ();
use lib 't/lib';

*_find_missing = \&Test::Needs::_find_missing;

my $have_vpm = eval { require version };

sub test_version {
    for my $v ($] - 0.001, $], $] + 0.001) {
      my $fail = $v > $];
      my @parts = sprintf('%.6f', $v) =~ /^(\d+)\.(\d{3})(\d{3})/;
      my $str_v = join '.', map $_+0, @parts;
      for my $c (
        $v,
        qq["$str_v"],
        qq["v$str_v"],
#        qq[v$str_v],
        qq[version->new("$str_v")]
      ) {
        SKIP: {
          skip "version.pm not available", 1
            if !$have_vpm && $c =~ /version->/;
          my $check = eval $c or die $@;
          my $message = _find_missing({ perl => $check });
          if ($fail) {
            is $message, sprintf("Need perl %.6f (have %.6f)", $v, $]),
              "perl prereq of $c failed";
          }
          else {
            is $message, undef,
              "perl prereq of $c passed";
          }
        }
      }
    }
}

{
    local $] = "5";
    test_version();
}

{
    local $] = "7";
    test_version();
}

{
    local $] = "5.000000";
    test_version();
}

{
    local $] = "7.000000";
    test_version();
}

__END__
sub xtest_version {
   for my $v ($] - 0.001, $], $] + 0.001) {
      my $fail = $v > $];
      my @parts = sprintf('%.6f', $v) =~ /^(\d+)\.(\d{3})(\d{3})/;
      my $str_v = join '.', map $_+0, @parts;
      for my $c (
#        $v,
#        qq["$str_v"],
#        qq["v$str_v"],
        qq[v$str_v],
#        qq[version->new("$str_v")]
      ) {
          SKIP: {
            skip "version.pm not available", 1
              if !$have_vpm && $c =~ /version->/;
            diag($c);
            my $check = eval $c or die $@;
            diag($check);
            my $message = _find_missing({ perl => $check });
#            if ($fail) {
##              is $message, sprintf("Need perl %.6f (have %.6f)", $v, $]),
##                "perl prereq of $c failed";
##            }
##            else {
##              is $message, undef,
##                "perl prereq of $c passed";
#            }
             diag($c);
          }
      }
    }
}

{
    local $] = "5";
    xtest_version();
}

{
    local $] = "7";
    xtest_version();
}

{
    local $] = "5.000000";
    xtest_version();
}

{
    local $] = "7.000000";
    xtest_version();
}

