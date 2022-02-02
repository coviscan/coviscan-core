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

package eu.europa.ec.dgc.validation.decorator.repository;

import eu.europa.ec.dgc.validation.decorator.config.DgcProperties.ServiceProperties;
import eu.europa.ec.dgc.validation.decorator.dto.DccTokenRequest;
import eu.europa.ec.dgc.validation.decorator.entity.ValidationServiceIdentityResponse;
import eu.europa.ec.dgc.validation.decorator.entity.ValidationServiceInitializeRequest;
import eu.europa.ec.dgc.validation.decorator.entity.ValidationServiceInitializeResponse;
import eu.europa.ec.dgc.validation.decorator.entity.ValidationServiceStatusResponse;
import eu.europa.ec.dgc.validation.decorator.service.AccessTokenService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Slf4j
@Service
@RequiredArgsConstructor
public class ValidationServiceRepository {

    private final RestTemplate restTpl;

    private final AccessTokenService accessTokenService;

    /**
     * Validation service identity endpoint. Example:
     * https://dgca-validation-service-eu-test.cfapps.eu10.hana.ondemand.com/.
     * 
     * @return {@link ValidationServiceIdentityResponse}
     */
    @Cacheable("vsidentity")
    public ValidationServiceIdentityResponse identity(final ServiceProperties service) {
        final String url = UriComponentsBuilder.fromUriString(service.getServiceEndpoint())
                .path("identity")
                .toUriString();

        log.debug("REST Call to '{}' starting", url);
        final ResponseEntity<ValidationServiceIdentityResponse> response = this.restTpl
                .getForEntity(url, ValidationServiceIdentityResponse.class);
        
        // Workaround: remove unsupported VerificationMethod
        final ValidationServiceIdentityResponse resBody = response.getBody();
        if (resBody.getVerificationMethod() != null) {
            resBody.getVerificationMethod().removeIf(method -> method.getPublicKeyJwk() == null);    
        }
        
        return resBody;
    }

    /**
     * Clear 'vsidentity' cache. 600.000 = 10m.
     */
    @Scheduled(fixedDelay = 600000, initialDelay = 10000)
    @CacheEvict(value = "vsidentity", allEntries = true)
    public void clearVsIdentityCache() {
        log.debug("Clear 'vsidentity' cache");
    }

    /**
     * Validation service initialize endpoint.
     * 
     * @param service {@link ServiceProperties}
     * @param dccToken {@link DccTokenRequest}
     * @param subject {@link String}
     * @return {@link ValidationServiceInitializeResponse}
     */
    public ValidationServiceInitializeResponse initialize(
            final ServiceProperties service,
            final DccTokenRequest dccToken,
            final String subject,
            final String nonce) {
        final String url = UriComponentsBuilder.fromUriString(service.getServiceEndpoint())
                .pathSegment("initialize", subject)
                .toUriString();

        final ValidationServiceInitializeRequest body = new ValidationServiceInitializeRequest();
        body.setPubKey(dccToken.getPubKey());
        body.setKeyType("ES256"); // FIXME source?
        body.setNonce(nonce);
        // TODO add callback

        final HttpHeaders headers = new HttpHeaders();
        headers.add("X-Version", "1.0");
        headers.add("Authorization", this.accessTokenService.buildHeaderToken(subject));

        final HttpEntity<ValidationServiceInitializeRequest> entity = new HttpEntity<>(body, headers);

        log.debug("REST Call to '{}' starting", url);
        final ResponseEntity<ValidationServiceInitializeResponse> response = this.restTpl
                .exchange(url, HttpMethod.PUT, entity, ValidationServiceInitializeResponse.class);
        return response.getBody();
    }

    /**
     * Validation service status endpoint.
     * 
     * @param subject {@link String}
     * @return {@link ValidationServiceStatusResponse}
     */
    public ValidationServiceStatusResponse status(final ServiceProperties service, final String subject) {
        final String url = UriComponentsBuilder.fromUriString(service.getServiceEndpoint())
                .pathSegment("status", subject)
                .toUriString();

        final HttpHeaders headers = new HttpHeaders();
        headers.add("X-Version", "1.0");
        headers.add("Authorization", this.accessTokenService.buildHeaderToken(subject));

        final HttpEntity<String> entity = new HttpEntity<>(headers);

        log.debug("REST Call to '{}' starting", url);
        final ResponseEntity<String> response = this.restTpl.exchange(url, HttpMethod.GET, entity, String.class);
        switch (response.getStatusCode()) {
            case OK:
                return new ValidationServiceStatusResponse(response.getStatusCodeValue(), response.getBody());
            case NO_CONTENT:
                return new ValidationServiceStatusResponse(response.getStatusCodeValue());
            default:
                return new ValidationServiceStatusResponse(response.getStatusCodeValue());
        }
    }
}
