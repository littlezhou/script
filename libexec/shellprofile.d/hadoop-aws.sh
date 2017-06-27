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
#
#
#
# IMPORTANT: This file is automatically generated by hadoop-dist at
#            -Pdist time.
#
#
if hadoop_verify_entry HADOOP_TOOLS_OPTIONS "hadoop-aws"; then
  hadoop_add_profile "hadoop-aws"
fi

function _hadoop-aws_hadoop_classpath
{
  if [[ -f "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/aws-java-sdk-bundle-1.11.134.jar" ]]; then
    hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/aws-java-sdk-bundle-1.11.134.jar"
  fi
  if [[ -f "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/java-xmlbuilder-0.4.jar" ]]; then
    hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/java-xmlbuilder-0.4.jar"
  fi
  if [[ -f "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/jets3t-0.9.0.jar" ]]; then
    hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/jets3t-0.9.0.jar"
  fi
  if [[ -f "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/joda-time-2.9.4.jar" ]]; then
    hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/joda-time-2.9.4.jar"
  fi
  if [[ -f "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/jackson-dataformat-cbor-2.7.8.jar" ]]; then
    hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/jackson-dataformat-cbor-2.7.8.jar"
  fi
  hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/hadoop-aws-3.0.0-alpha4-SNAPSHOT.jar"
}
