#!/bin/bash

if [ -t 1 ]; then # test if stdout is a terminal
	BoldRed='\033[1;31m'
	BoldGreen='\033[1;32m'
	ResetColor='\033[0m'
else
	BoldRed=''
	BoldGreen=''
	ResetColor=''
fi


function Error
{
	echo -e "${BoldRed}$*${ResetColor}" >&2
	exit 1
}

if [ "$#" -lt '2' ]; then
	echo "Usage: $(basename "$0") <source dir> <log dir>"
	exit 1
fi

function AbsPath
{
	readlink -f "$1"
}

SourceDir="$(AbsPath "$1")"
LogDir="$(AbsPath "$2")"

TempDir="/tmp/vmanTest-$RANDOM"
mkdir -p "$TempDir"
trap "rm -rf $TempDir" EXIT


let SuccessCount=0
let FailureCount=0

function RunTest
{
	local testName="$1"
	local testExecutable="$SourceDir/$2"
	shift 2

	printf 'Running %-16s' "$testName ... "
	local logFile="$LogDir/$testName.log"

	if [ ! -e "$testExecutable" ]; then
		Error "Can't find '$testExecutable'!."
	fi
	
	rm -rf "$TempDir/*" # Clean up previous garbage

	local old="$PWD"
	cd "$TempDir"
	$("$testExecutable" $@ &> "$logFile") # $()-Hack that supresses segfault messages
	status="$?"

	cd "$old"
	if [ "$status" == '0' ]; then
		echo -e "${BoldGreen}success${ResetColor}"
		let SuccessCount++
	else
		echo -e "${BoldRed}failure${ResetColor}"
		let FailureCount++
	fi
}

RunTest 'path' 'path'
RunTest 'test' 'test'
RunTest 'volume' 'volume'
RunTest 'chunk' 'chunk'
RunTest 'access' 'access'


let TotalCount=SuccessCount+FailureCount
echo "$FailureCount of $TotalCount tests failed."

if [ "$FailureCount" != '0' ]; then
	exit 1
fi
