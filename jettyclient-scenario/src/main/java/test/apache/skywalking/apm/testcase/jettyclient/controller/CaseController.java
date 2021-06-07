/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package test.apache.skywalking.apm.testcase.jettyclient.controller;

import javax.annotation.PostConstruct;
import org.eclipse.jetty.client.HttpClient;
import org.eclipse.jetty.client.api.ContentResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/case")
@PropertySource("classpath:application.properties")
public class CaseController {
    private static final Logger logger = LoggerFactory.getLogger(CaseController.class);

    @Value(value = "${jettyServer.host:localhost}")
    private String jettyServerHost;

    @Value(value = "${jettyServer.port:18080}")
    private String jettyServerPort;

    private HttpClient client = new HttpClient();

    @PostConstruct
    public void init() throws Exception {
        client.start();
    }

    @RequestMapping("/jettyclient-case")
    @ResponseBody
    public String jettyClientScenario() throws Exception {
        logger.info("jetty-client request.");
        ContentResponse response = client.newRequest(
            "http://" + jettyServerHost + ":" + jettyServerPort + "/jettyserver-case/case/receiveContext-0"
        ).send();
        logger.info(response.getContentAsString());
        return "Success";
    }

    @RequestMapping("/healthCheck")
    @ResponseBody
    public String healthCheck() throws Exception {
        logger.info("jetty-client health check.");
        return "Success";
    }
}
