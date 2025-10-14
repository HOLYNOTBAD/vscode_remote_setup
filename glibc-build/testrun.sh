 #!/bin/bash
builddir=`dirname "$0"`
GCONV_PATH="${builddir}/iconvdata"

usage () {
  echo "usage: $0 [--tool=strace] PROGRAM [ARGUMENTS...]" 2>&1
  echo "       $0 --tool=valgrind PROGRAM [ARGUMENTS...]" 2>&1
}

toolname=default
while test $# -gt 0 ; do
  case "$1" in
    --tool=*)
      toolname="${1:7}"
      shift
      ;;
    --*)
      usage
      ;;
    *)
      break
      ;;
  esac
done

if test $# -eq 0 ; then
  usage
fi

case "$toolname" in
  default)
    exec   env GCONV_PATH="${builddir}"/iconvdata LOCPATH="${builddir}"/localedata LC_ALL=C  "${builddir}"/elf/ld-linux-x86-64.so.2 --library-path "${builddir}":"${builddir}"/math:"${builddir}"/elf:"${builddir}"/dlfcn:"${builddir}"/nss:"${builddir}"/nis:"${builddir}"/rt:"${builddir}"/resolv:"${builddir}"/mathvec:"${builddir}"/support:"${builddir}"/crypt:"${builddir}"/nptl ${1+"$@"}
    ;;
  strace)
    exec strace  -EGCONV_PATH=/home/holy/vscode_remote_setup/glibc-build/iconvdata  -ELOCPATH=/home/holy/vscode_remote_setup/glibc-build/localedata  -ELC_ALL=C  /home/holy/vscode_remote_setup/glibc-build/elf/ld-linux-x86-64.so.2 --library-path /home/holy/vscode_remote_setup/glibc-build:/home/holy/vscode_remote_setup/glibc-build/math:/home/holy/vscode_remote_setup/glibc-build/elf:/home/holy/vscode_remote_setup/glibc-build/dlfcn:/home/holy/vscode_remote_setup/glibc-build/nss:/home/holy/vscode_remote_setup/glibc-build/nis:/home/holy/vscode_remote_setup/glibc-build/rt:/home/holy/vscode_remote_setup/glibc-build/resolv:/home/holy/vscode_remote_setup/glibc-build/mathvec:/home/holy/vscode_remote_setup/glibc-build/support:/home/holy/vscode_remote_setup/glibc-build/crypt:/home/holy/vscode_remote_setup/glibc-build/nptl ${1+"$@"}
    ;;
  valgrind)
    exec env GCONV_PATH=/home/holy/vscode_remote_setup/glibc-build/iconvdata LOCPATH=/home/holy/vscode_remote_setup/glibc-build/localedata LC_ALL=C valgrind  /home/holy/vscode_remote_setup/glibc-build/elf/ld-linux-x86-64.so.2 --library-path /home/holy/vscode_remote_setup/glibc-build:/home/holy/vscode_remote_setup/glibc-build/math:/home/holy/vscode_remote_setup/glibc-build/elf:/home/holy/vscode_remote_setup/glibc-build/dlfcn:/home/holy/vscode_remote_setup/glibc-build/nss:/home/holy/vscode_remote_setup/glibc-build/nis:/home/holy/vscode_remote_setup/glibc-build/rt:/home/holy/vscode_remote_setup/glibc-build/resolv:/home/holy/vscode_remote_setup/glibc-build/mathvec:/home/holy/vscode_remote_setup/glibc-build/support:/home/holy/vscode_remote_setup/glibc-build/crypt:/home/holy/vscode_remote_setup/glibc-build/nptl ${1+"$@"}
    ;;
  *)
    usage
    ;;
esac
