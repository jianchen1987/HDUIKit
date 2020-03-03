#!/bin/bash

pod_name=HDUIKit

push_podspec_name=$pod_name.podspec

subspecs=($pod_name)

podspec_path=$PWD/$push_podspec_name

# 获取版本号
version=`grep -E "s.version |s.version=" $podspec_path | head -1 | sed 's/'s.version'//g' | sed 's/'='//g'| sed 's/'\"'//g'| sed 's/'\''//g' | sed 's/'[[:space:]]'//g'`


for subspec in ${subspecs[@]}
do
  # 打包指令
  subspec="${subspec}" pod package $pod_name.podspec --subspecs="${subspec}" --no-mangle --exclude-deps --force  --spec-sources=https://github.com/CocoaPods/Specs.git,git@git.vipaylife.com:wangwanjie/tianxu-specs.git

  # 打包完 commit，避免 package 时还是使用旧的代码
  git add .
  git commit -m "package ${subspec}"
done


git push origin master

git tag -d $version
git push origin :refs/tags/$version

git tag -a $version -m $version
git push origin --tags
pod cache clean --all

pod repo push Chaos "${push_podspec_name}" --allow-warnings --verbose --sources=https://github.com/CocoaPods/Specs.git,git@git.vipaylife.com:wangwanjie/tianxu-specs.git