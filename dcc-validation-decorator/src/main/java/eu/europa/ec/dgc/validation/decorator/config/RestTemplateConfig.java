/*-
 * ---license-start
 * Copyright (C) 2022 Coviscan and all other contributors
 * ---
 * European Digital COVID Certificate Validation Decorator Service / dgca-validation-decorator
 * ---
 * Copyright (C) 2021 T-Systems International GmbH and all other contributors
 * ---
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---license-end
 */

package eu.europa.ec.dgc.validation.decorator.config;

import java.time.Duration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfig {

    @Value("${identity.restTemplate.connectionTimeout:3000}")
    private int connectionTimeout;

    @Value("${identity.restTemplate.readTimeout:3000}")
    private int readTimeout;

    /**
     * Build {@link RestTemplate} for current project.
     * 
     * @param builder {@link RestTemplateBuilder}
     * @return {@link RestTemplate}
     */
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder.setConnectTimeout(Duration.ofMillis(this.connectionTimeout))
                .setReadTimeout(Duration.ofMillis(this.readTimeout))
                .build();
    }
}
