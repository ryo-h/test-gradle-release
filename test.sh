#!/bin/bash
tags=(`git tag | grep ^v[0-9] | sed -e "s/v//" | sort -n -r`)

if [ "${#tagval[@]}" -gt "1" ]
then
  latest=${tags[0]}
  echo ${latest}
  tagval=(`echo ${latest} | awk -F\. '{print $1,$2,$3}'`)

  if [ "${#tagval[@]}" -ne "3" ]
    then
    echo "invalid tag"
    exit 1
  fi

  release_minor_version=`expr ${tagval[1]} + 1`
  next_minor_version=`expr ${release_minor_version} + 1`
  release_version=${tagval[0]}.${release_minor_version}.0
  new_version=${tagval[0]}.${next_minor_version}.0-SNAPSHOT

  echo ${release_version}
  echo ${new_version}
else
  release_version=1.0.0
  new_version=1.1.0-SNAPSHOT
fi

gradle release -Prelease.useAutomaticVersion=true -Prelease.releaseVersion=${release_version} -Prelease.newVersion=${new_version}
