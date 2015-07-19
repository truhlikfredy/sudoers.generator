#!/bin/bash

function getAllLinks {
  if [ -d $1 ]; then
    cd $1
    links=""
    for link in *
    do
      linkTarget=`readlink $link`
      links="$links $linkTarget,"
    done
    #display whole $links varibale except the last character (which is comma)
    echo ${links::-1}
    cd ..
  else 
    echo ""
  fi
}

for user in *.user
do
  user=`echo $user | cut -d'.' -f1` 
  echo "Generating sudoers for $user"
  cd $user.user
  rm $user.sudoer 1>/dev/null 2>&1 
  
  links=$(getAllLinks password)
  if [ -n "$links" ]; then
    echo "$user ALL=$links" >> $user.sudoer
  fi
    
  links=$(getAllLinks nopassword)
  if [ -n "$links" ]; then
    echo "$user ALL=NOPASSWD: $links" >> $user.sudoer
  fi

  cd ..
done