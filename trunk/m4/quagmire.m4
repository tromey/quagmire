## -*- Autoconf -*-

# AM_QUAGMIRE([DIR])
# Set up for Quagmire.
# DIR is the directory of the quagmire .mk files, relative to $srcdir.
# Defaults to quagmire.
AC_DEFUN([AM_QUAGMIRE],[
if test -n "$1"; then
  quagmire_dir="$1"
else
  quagmire_dir=quagmire
fi
quagmire_dir='$(abs_srcdir)'/$quagmire_dir
AC_SUBST(quagmire_dir)

# Ugly hacks relying on autoconf internals.  Note that we do this here
# because the commands for AC_CONFIG_FILES are run after the file is
# built.  This isn't ideal but there doesn't seem to be a better way.
test -d .quagmire || mkdir .quagmire
(echo "## Makefile by Quagmire"
echo
for var in $ac_subst_vars; do
  # FIXME: we'd like to use := here, but autoconf defines exec_prefix
  # before prefix... and of course we don't know what horrible thing
  # the user might do.
  echo "$var = @$var@"
done
# FIXME: strangely, there are a few variables that autoconf always
# substitutes but which don't appear in the list.  We don't output
# all of them here (we don't care about some builddir variants).
echo
for var in abs_builddir srcdir abs_srcdir; do
  echo "$var = @$var@"
done
echo
echo 'include $(quagmire_dir)/base.mk') > .quagmire/variables.in

AC_CONFIG_COMMANDS_PRE([
  quagmire_config_files=$ac_config_files
  AC_SUBST(quagmire_config_files)
])

AC_CONFIG_FILES([Makefile:.quagmire/variables.in])])
