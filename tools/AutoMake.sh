#!/bin/bash

PROJECT=$1

DEVICE=$2
USR=userdebug

BASEDIR=/home/c_dshao/
PREFIX=AutoMake/
SUFFIX=$(date +%Y%m%d -d "today")
SUFFIX_1=$(date +%Y%m%d -d "yesterday")
SUFFIX_2=$(date +%Y%m%d -d "2 days ago")

BIN=bin
REPO=repo

LUNCH=lunch
MAKE=make

AUPA=AutoPatch.sh
PATCHFILE=patchlist_xxx.txt
PATCHLIST=$BASEDIR$PREFIX$PATCHFILE

#########    env setup    ###########

ROOT=$BASEDIR$PREFIX$PROJECT
#DIR_2=$BASEDIR$PREFIX$SUFFIX_2
#ROOT_2=$DIR_2/$PROJECT
export ROOT

export PATH=$BASEDIR$BIN:$PATH

##########  make a folder ###########

# delete old soucre code
#if [ -d "$ROOT_2" ]; then
#	rm -rf $ROOT_2
#fi

#if [ "$(ls -A $DIR_2)" ]; then
#	echo ""
#else
#	rm -rf $DIR_2
#fi

#if [ -d "$ROOT" ]; then
#	rm -rf $ROOT
#fi

#mkdir -p $ROOT

cd $ROOT

# keep .repo to use on next time
rm -rf *

#########    sync code    ###########

#cp -rf $BASEDIR$PREFIX.repo_$PROJECT $ROOT/.repo
#$REPO init -u git://git.quicinc.com/platform/manifest.git -b $PROJECT -m versioned.xml --repo-url=git://git.quicinc.com/tools/repo.git 

$REPO sync -j8

$REPO start --all base_$SUFFIX

#########    AutoPatch    ###########

#if [ -d "$PATCHLIST" ]; then
#	. $BASEDIR$BIN/$AUPA -apply -f $PATCHLIST
#fi

#########     make it     ###########

source $ROOT/build/envsetup.sh

$LUNCH $DEVICE-$USR

time $MAKE -j8 | tee $ROOT/$SUFFIX-make-$PROJECT.txt

time $MAKE cts -j8 | tee $ROOT/$SUFFIX-make-cts.txt

## copy flash shell to out folder
cp $BASEDIR$BIN/flash.sh $ROOT/out/target/product/$DEVICE/ 
