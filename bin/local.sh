#!/bin/bash

home="$(cd "$(dirname $0)"; pwd)"

export SW_HOME=/Users/tenyzh/apache-skywalking-apm-bin/agent

export agent_opts="-javaagent:${SW_HOME}/skywalking-agent.jar
    -Dskywalking.collector.grpc_channel_check_interval=2
    -Dskywalking.collector.app_and_service_register_check_interval=2
    -Dskywalking.collector.discovery_check_interval=2
    -Dskywalking.collector.backend_service=${COLLECTOR}
    -Dskywalking.logging.dir=${SW_HOME}/logs
    -DSW_KAFKA_BOOTSTRAP_SERVERS=localhost:9092
    -Xms256m -Xmx256m"


java -jar ${agent_opts} "-Dskywalking.agent.service_name=jettyserver-scenario" ${home}/../jettyserver-scenario/target/jettyserver-scenario.jar
