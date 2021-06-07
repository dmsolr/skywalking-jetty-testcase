#!/bin/bash

home="$(cd "$(dirname $0)"; pwd)"

SW_HOME=${agent_home:-/Users/tenyzh/apache-skywalking-apm-bin/agent}

export agent_opts="-javaagent:${SW_HOME}/skywalking-agent.jar
    -Dskywalking.collector.grpc_channel_check_interval=2
    -Dskywalking.collector.app_and_service_register_check_interval=2
    -Dskywalking.collector.discovery_check_interval=2
    -Dskywalking.collector.backend_service=${COLLECTOR:-localhost:11800}
    -Dskywalking.logging.dir=${SW_HOME}/logs
    -Xms256m -Xmx256m"

if [[ -n $KAFKA_SEVERS ]]; then
  agent_opts="$agent_opts -DSW_KAFKA_BOOTSTRAP_SERVERS=${KAFKA_SERVERS}"
fi

java -jar ${agent_opts} "-Dskywalking.agent.service_name=jettyserver-scenario" ${home}/../jettyserver-scenario/target/jettyserver-scenario.jar &
pid1=$!
sleep 1

java -jar ${agent_opts} "-Dskywalking.agent.service_name=jettyclient-scenario" ${home}/../jettyclient-scenario/target/jettyclient-scenario.jar &
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
