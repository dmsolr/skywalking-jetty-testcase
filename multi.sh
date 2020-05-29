#!/bin/bash

export agent_opts="-javaagent:/root/skywalking/skywalking-agent/skywalking-agent.jar
    -Dskywalking.collector.grpc_channel_check_interval=2
    -Dskywalking.collector.app_and_service_register_check_interval=2
    -Dskywalking.collector.discovery_check_interval=2
    -Dskywalking.collector.backend_service=localhost:11800
    -Dskywalking.logging.dir=/root/skywalking/skywalking-agent/logs
    -DSW_KAFKA_BOOTSTRAP_SERVERS=localhost:9092
    -Xms256m -Xmx256m"

java -jar ${agent_opts} "-Dskywalking.agent.service_name=jettyserver-scenario" jettyserver-scenario/target/jettyserver-scenario.jar &
pid1=$!
sleep 1

java -jar ${agent_opts} "-Dskywalking.agent.service_name=jettyclient-scenario"  ./jettyclient-scenario/target/jettyclient-scenario.jar &
pid2=$!
sleep 10

url="http://localhost:8080/jettyclient-case/case/jettyclient-case"
healthcheck="http://localhost:8080/jettyclient-case/case/healthCheck"
for (( i=0; i<30; i++ )) do
  curl -s ${healthcheck}
  sleep 1
  curl -s ${url}
done

kill $pid1 $pid2 
