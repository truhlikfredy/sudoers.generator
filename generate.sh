#!/bin/bash

function getAllLinks {
  if [ -d $1 ] && [ "$(ls -A $1)" ]; then
    cd $1
    links=""
    for link in *
    do
      linkTarget=`readlink $link`
      links="$links $linkTarget,"
    done
    cd ..
    #save whole $links varibale except the last character (which is comma)
    echo "$user $2 ${links::-1}" >> $user.sudoer
  fi
}

for user in *.user
do
  user=`echo $user | cut -d'.' -f1` 
  echo "Generating sudoers for $user"
  cd $user.user
  rm $user.sudoer 1>/dev/null 2>&1 
  
  getAllLinks password "ALL="
  getAllLinks nopassword "ALL=NOPASSWD:"

  cd ..
done