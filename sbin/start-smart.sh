#!/usr/bin/env bash

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


#SMART_HOME

function hadoop_usage
{
  echo "Usage: start-smart.sh "
}

this="${BASH_SOURCE-$0}"
bin=$(cd -P -- "$(dirname -- "${this}")" >/dev/null && pwd -P)

# let's locate libexec...
if [[ -n "${SMART_HOME}" ]]; then
  SMART_DEFAULT_LIBEXEC_DIR="${SMART_HOME}/libexec"
else
  SMART_DEFAULT_LIBEXEC_DIR="${bin}/../libexec"
fi

SMART_LIBEXEC_DIR="${SMART_LIBEXEC_DIR:-$SMART_DEFAULT_LIBEXEC_DIR}"
# shellcheck disable=SC2034
SMART_NEW_CONFIG=true
if [[ -f "${SMART_LIBEXEC_DIR}/smart-config.sh" ]]; then
  . "${SMART_LIBEXEC_DIR}/smart-config.sh"
else
  echo "ERROR: Cannot execute ${SMART_LIBEXEC_DIR}/smart-config.sh." 2>&1
  exit 1
fi

# # get arguments
# if [[ $# -ge 1 ]]; then
#   startOpt="$1"
#   shift
#   case "$startOpt" in
#     -upgrade)
#       nameStartOpt="$startOpt"
#     ;;
#     -rollback)
#       dataStartOpt="$startOpt"
#     ;;
#     *)
#       hadoop_exit_with_usage 1
#     ;;
#   esac
# fi


#Add other possible options
nameStartOpt="$nameStartOpt $*"

echo "=== ${nameStartOpt} ==="

#---------------------------------------------------------
# Smart server

NAMENODES=$("${SMART_HDFS_HOME}/bin/smart" getconf -namenodes 2>/dev/null)

if [[ -z "${NAMENODES}" ]]; then
  NAMENODES=$(hostname)
fi

echo "NAMENODES=" ${NAMENODES}

# echo "Starting namenodes on [${NAMENODES}]"
# hadoop_uservar_su smart namenode "${SMART_HDFS_HOME}/bin/hdfs" \
#     --workers \
#     --config "${SMART_CONF_DIR}" \
#     --hostnames "${NAMENODES}" \
#     --daemon start \
#     namenode ${nameStartOpt}

# SMART_JUMBO_RETCOUNTER=$?

#---------------------------------------------------------
# Slave smart servers (if any)

#---------------------------------------------------------
# Agents (if any)


# eof
