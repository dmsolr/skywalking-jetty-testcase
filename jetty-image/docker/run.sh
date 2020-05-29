#!/bin/bash

export agent_opts="-javaagent:/var/lib/agent/skywalking-agent.jar
    -Dskywalking.collector.grpc_channel_check_interval=2
    -Dskywalking.collector.app_and_service_register_check_interval=2
    -Dskywalking.collector.discovery_check_interval=2
    -Dskywalking.collector.backend_service=${collector}
    -Dskywalking.logging.dir=/var/lib/agent/logs
    -Xms256m -Xmx256m"

java -jar ${agent_opts} "-Dskywalking.agent.service_name=jettyserver-scenario" ./jettyserver-scenario.jar &
sleep 1

java -jar ${agent_opts} "-Dskywalking.agent.service_name=jettyclient-scenario"  ./jettyclient-scenario.jar &

sleep 10

url="http://localhost:8080/jettyclient-case/case/jettyclient-case"
healthcheck="http://localhost:8080/jettyclient-case/case/healthCheck"
for (( i=0; i<10000; i++ )) do
  echo "${healthcheck}"
  curl ${healthcheck}
  sleep 1
  echo "${url}"
  curl ${url}
done
