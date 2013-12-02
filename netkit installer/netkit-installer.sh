#!/bin/bash
# Author: Raffaele Vacchiano
#

check()
{
  command -v wget >/dev/null 2>&1 || { echo "wget is needed, install it"; return 1; }
  command -v curl >/dev/null 2>&1 || { echo "curl is needed, install it";return 1; }
  command -v tar >/dev/null 2>&1 || { echo "tar is needed, install it"; return 1; }
}

install()
{
  elems=( $(curl http://wiki.netkit.org/index.php/Download_Official | grep http://wiki.netkit.org/download/netkit | grep tar | head -n3 | awk '{"http"; print $3;}' | sed s/"href=\""/""/ | sed s/"\""/""/ ) )

  current=`pwd`

  cd $HOME

  for i in ${elems[@]}
  do
    echo
    echo "downloading" ${i##*/}
    wget $i
    echo
    echo "uncompressing it"
    tar xjSf ${i##*/}
    echo
    echo "removing"
    rm ${i##*/}
  done

  if [ "`cat .bashrc | grep "export NETKIT_HOME"`" == "" ] 
  then
    echo "#NETKIT" >> .bashrc
    echo "export NETKIT_HOME="$HOME"/netkit" >> .bashrc
    echo "export PATH=$PATH:$NETKIT_HOME/bin" >> .bashrc
    echo "export MANPATH=:$NETKIT_HOME/man" >> .bashrc
    echo "####" >> .bashrc
  else
    echo
    cat .bashrc > .bashrc.bak
    sed '0,/NETKIT_HOME=[^=]*$/s||NETKIT_HOME='$HOME/netkit'|' .bashrc > tmp
    mv tmp .bashrc
    echo "updated NETKIT_HOME and backed up .bashrc to .bashrc.bak"
  fi

  cd $current

  echo
  echo "Netkit installed in "$HOME"/netkit"
}

if check
  then install;
fi
