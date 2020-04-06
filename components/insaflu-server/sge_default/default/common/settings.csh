setenv SGE_ROOT /opt/sge

if ( -x $SGE_ROOT/util/arch ) then
setenv SGE_ARCH `$SGE_ROOT/util/arch`
set DEFAULTMANPATH = `$SGE_ROOT/util/arch -m`
set MANTYPE = `$SGE_ROOT/util/arch -mt`

setenv SGE_CELL default
setenv SGE_CLUSTER_NAME p6444
unsetenv SGE_QMASTER_PORT
unsetenv SGE_EXECD_PORT
setenv DRMAA_LIBRARY_PATH /opt/sge/lib//libdrmaa.so

# library path setting required only for architectures where RUNPATH is not supported
if ( -d $SGE_ROOT/$MANTYPE ) then
   if ( $?MANPATH == 1 ) then
      setenv MANPATH $SGE_ROOT/${MANTYPE}:$MANPATH
   else
      setenv MANPATH $SGE_ROOT/${MANTYPE}:$DEFAULTMANPATH
   endif
endif

set path = ( $SGE_ROOT/bin $SGE_ROOT/bin/$SGE_ARCH  $path )
if ( -d $SGE_ROOT/lib/$SGE_ARCH ) then
   switch ($SGE_ARCH)
case "sol*":
case "lx*":
case "hp11-64":
   breaksw
   case "*":
      set shlib_path_name = `$SGE_ROOT/util/arch -lib`
      if ( `eval echo '$?'$shlib_path_name` ) then
         set old_value = `eval echo '$'$shlib_path_name`
         setenv $shlib_path_name "$SGE_ROOT/lib/$SGE_ARCH":"$old_value"
      else
         setenv $shlib_path_name $SGE_ROOT/lib/$SGE_ARCH
      endif
      unset shlib_path_name  old_value
   endsw
endif
unset DEFAULTMANPATH MANTYPE
else
unsetenv SGE_ROOT
endif
