#!/bin/bash

export agent_opts="-javaagent:/root/skywalking/skywalking-agent/skywalking-agent.jar
    -Dskywalking.collector.grpc_channel_check_interval=2
    -Dskywalking.collector.app_and_service_register_check_interval=2
    -Dskywalking.collector.discovery_check_interval=2
    -Dskywalking.collector.backend_service=localhost:11800
    -Dskywalking.logging.dir=/root/skywalking/skywalking-agent/logs
    -DSW_KAFKA_BOOTSTRAP_SERVERS=localhost:9092
    -Xms256m -Xmx256m"

java -jar ${agent_opts} "-Dskywalking.agent.service_name=jettyserver-scenario" jettyserver-scenario/target/jettyserver-scenario.jar
