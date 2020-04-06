SGE_ROOT=/opt/sge; export SGE_ROOT

if [ -x $SGE_ROOT/util/arch ]; then
SGE_ARCH=`$SGE_ROOT/util/arch`; export SGE_ARCH
DEFAULTMANPATH=`$SGE_ROOT/util/arch -m`
MANTYPE=`$SGE_ROOT/util/arch -mt`
DRMAA_LIBRARY_PATH=/opt/sge/lib//libdrmaa.so

SGE_CELL=default; export SGE_CELL
SGE_CLUSTER_NAME=p6444; export SGE_CLUSTER_NAME
unset SGE_QMASTER_PORT
unset SGE_EXECD_PORT

if [ -d "$SGE_ROOT/$MANTYPE" ]; then
   if [ "$MANPATH" = "" ]; then
      MANPATH=$DEFAULTMANPATH
   fi
   MANPATH=$SGE_ROOT/$MANTYPE:$MANPATH; export MANPATH
fi

PATH=$SGE_ROOT/bin:$SGE_ROOT/bin/$SGE_ARCH:$PATH; export PATH
# library path setting required only for architectures where RUNPATH is not supported
if [ -d $SGE_ROOT/lib/$SGE_ARCH ]; then
   case $SGE_ARCH in
sol*|lx*|hp11-64)
   ;;
   *)
      shlib_path_name=`$SGE_ROOT/util/arch -lib`
      old_value=`eval echo '$'$shlib_path_name`
      if [ x$old_value = x ]; then
         eval $shlib_path_name=$SGE_ROOT/lib/$SGE_ARCH
      else
         eval $shlib_path_name=$SGE_ROOT/lib/$SGE_ARCH:$old_value
      fi
      export $shlib_path_name
      unset shlib_path_name old_value
      ;;
   esac
fi
unset DEFAULTMANPATH MANTYPE
else
unset SGE_ROOT
fi
