#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

####
# IMPORTANT
####

## The hadoop-config.sh tends to get executed by non-Hadoop scripts.
## Those parts expect this script to parse/manipulate $@. In order
## to maintain backward compatibility, this means a surprising
## lack of functions for bits that would be much better off in
## a function.
##
## In other words, yes, there is some bad things happen here and
## unless we break the rest of the ecosystem, we can't change it. :(


# included in all the hadoop scripts with source command
# should not be executable directly
# also should not be passed any arguments, since we need original $*
#
# after doing more config, caller should also exec finalize
# function to finish last minute/default configs for
# settings that might be different between daemons & interactive

# you must be this high to ride the ride
if [[ -z "${BASH_VERSINFO[0]}" ]] \
   || [[ "${BASH_VERSINFO[0]}" -lt 3 ]] \
   || [[ "${BASH_VERSINFO[0]}" -eq 3 && "${BASH_VERSINFO[1]}" -lt 2 ]]; then
  echo "bash v3.2+ is required. Sorry."
  exit 1
fi
echo "KKKKKKKKKK"
# In order to get partially bootstrapped, we need to figure out where
# we are located. Chances are good that our caller has already done
# this work for us, but just in case...

if [[ -z "${SMART_LIBEXEC_DIR}" ]]; then
  _smart_common_this="${BASH_SOURCE-$0}"
  SMART_LIBEXEC_DIR=$(cd -P -- "$(dirname -- "${_smart_common_this}")" >/dev/null && pwd -P)
fi

# get our functions defined for usage later
if [[ -n "${SMART_COMMON_HOME}" ]] &&
   [[ -e "${SMART_COMMON_HOME}/libexec/smart-functions.sh" ]]; then
  # shellcheck source=./hadoop-common-project/hadoop-common/src/main/bin/smart-functions.sh
  . "${SMART_COMMON_HOME}/libexec/smart-functions.sh"
elif [[ -e "${SMART_LIBEXEC_DIR}/smart-functions.sh" ]]; then
  # shellcheck source=./hadoop-common-project/hadoop-common/src/main/bin/smart-functions.sh
  . "${SMART_LIBEXEC_DIR}/smart-functions.sh"
else
  echo "ERROR: Unable to exec ${SMART_LIBEXEC_DIR}/smart-functions.sh." 1>&2
  exit 1
fi

hadoop_deprecate_envvar SMART_PREFIX SMART_HOME

# allow overrides of the above and pre-defines of the below
if [[ -n "${SMART_COMMON_HOME}" ]] &&
   [[ -e "${SMART_COMMON_HOME}/libexec/smart-layout.sh" ]]; then
  # shellcheck source=./hadoop-common-project/hadoop-common/src/main/bin/smart-layout.sh.example
  . "${SMART_COMMON_HOME}/libexec/smart-layout.sh"
elif [[ -e "${SMART_LIBEXEC_DIR}/smart-layout.sh" ]]; then
  # shellcheck source=./hadoop-common-project/hadoop-common/src/main/bin/smart-layout.sh.example
  . "${SMART_LIBEXEC_DIR}/smart-layout.sh"
fi
echo "ASASASA"
#
# IMPORTANT! We are not executing user provided code yet!
#

# Let's go!  Base definitions so we can move forward
hadoop_bootstrap

# let's find our conf.
#
# first, check and process params passed to us
# we process this in-line so that we can directly modify $@
# if something downstream is processing that directly,
# we need to make sure our params have been ripped out
# note that we do many of them here for various utilities.
# this provides consistency and forces a more consistent
# user experience


# save these off in case our caller needs them
# shellcheck disable=SC2034
SMART_USER_PARAMS=("$@")

hadoop_parse_args "$@"
shift "${SMART_PARSE_COUNTER}"

#
# Setup the base-line environment
#
echo "xxxxxxxxxxxxx"
hadoop_find_confdir
echo "========="
hadoop_exec_hadoopenv
hadoop_import_shellprofiles
hadoop_exec_userfuncs

#
# IMPORTANT! User provided code is now available!
#
echo "GGGGG"

hadoop_exec_user_hadoopenv
hadoop_verify_confdir
echo "ffffff11111"
hadoop_deprecate_envvar SMART_SLAVES SMART_WORKERS
hadoop_deprecate_envvar SMART_SLAVE_NAMES SMART_WORKER_NAMES
hadoop_deprecate_envvar SMART_SLAVE_SLEEP SMART_WORKER_SLEEP
echo "ffffff1222222"
# do all the OS-specific startup bits here
# this allows us to get a decent JAVA_HOME,
# call crle for LD_LIBRARY_PATH, etc.
hadoop_os_tricks

hadoop_java_setup

hadoop_basic_init
echo "ffffff"

# inject any sub-project overrides, defaults, etc.
if declare -F hadoop_subproject_init >/dev/null ; then
  hadoop_subproject_init
fi

hadoop_shellprofiles_init

# get the native libs in there pretty quick
hadoop_add_javalibpath "${SMART_HOME}/build/native"
hadoop_add_javalibpath "${SMART_HOME}/${SMART_COMMON_LIB_NATIVE_DIR}"

hadoop_shellprofiles_nativelib

echo "SSSSSSSSSSS"

# get the basic java class path for these subprojects
# in as quickly as possible since other stuff
# will definitely depend upon it.
echo "SSSSSSSSSSS111111"
hadoop_add_common_to_classpath
hadoop_shellprofiles_classpath

# user API commands can now be run since the runtime
# environment has been configured
hadoop_exec_hadooprc
echo "SSSSSSSSSSS222222"
#
# backwards compatibility. new stuff should
# call this when they are ready
#
if [[ -z "${SMART_NEW_CONFIG}" ]]; then
  hadoop_finalize
fi
echo "============ finalized"