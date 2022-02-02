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

package eu.europa.ec.dgc.validation.decorator.controller;

import static org.assertj.core.api.Assertions.assertThat;
import eu.europa.ec.dgc.validation.decorator.config.IdentityProperties;
import eu.europa.ec.dgc.validation.decorator.dto.QrCodeDto;
import eu.europa.ec.dgc.validation.decorator.service.AccessTokenService;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.util.UriComponentsBuilder;

@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
class InitializeControllerTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTpl;

    @Autowired
    private IdentityProperties properties;

    @Autowired
    private AccessTokenService accessTokenService;

    @Test
    void initialize_withRandomSubject_successQrCode() {
        // GIVEN
        final String subject = UUID.randomUUID().toString();
        final String url = UriComponentsBuilder.fromUriString("http://localhost")
                .port(this.port)
                .path(InitializeController.PATH.replace("{subject}", subject))
                .toUriString();
        // WHEN        
        final ResponseEntity<QrCodeDto> result = this.restTpl.exchange(
                url, HttpMethod.GET, null, QrCodeDto.class);
        // THEN
        assertThat(result).isNotNull();
        assertThat(result.getStatusCode()).isEqualTo(HttpStatus.OK);
        // AND header
        assertThat(result.getHeaders()).containsKeys("Cache-Control");
        assertThat(result.getHeaders().get("Cache-Control")).contains("no-cache");
        // AND body 
        final QrCodeDto qrCode = result.getBody();
        assertThat(qrCode).isNotNull();
        assertThat(qrCode.getProtocol()).isEqualTo(this.properties.getProtocol());
        assertThat(qrCode.getProtocolVersion()).isEqualTo(this.properties.getProtocolVersion());
        assertThat(qrCode.getServiceIdentity()).isEqualTo(this.properties.getServiceIdentityUrl());
        assertThat(qrCode.getPrivacyUrl()).isEqualTo(this.properties.getPrivacyUrl());
        assertThat(qrCode.getConsent()).isEqualTo(this.properties.getConsent());
        assertThat(qrCode.getSubject()).isEqualTo(subject);
        assertThat(qrCode.getServiceProvider()).isEqualTo(this.properties.getServiceProvider());
        // AND token
        assertThat(qrCode.getToken()).isNotBlank();
        assertThat(this.accessTokenService.isValid(qrCode.getToken())).isTrue();
    }
}
