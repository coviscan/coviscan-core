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

package eu.europa.ec.dgc.validation.decorator.service;

import eu.europa.ec.dgc.validation.decorator.config.IdentityProperties;
import eu.europa.ec.dgc.validation.decorator.dto.QrCodeDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class InitializeService {

    private final IdentityProperties properties;

    private final AccessTokenService accessTokenService;

    /**
     * Build data for QR code with given subject.
     * 
     * @param subject Subject
     * @return {@link QrCodeDto}
     */
    public QrCodeDto getBySubject(String subject) {
        return QrCodeDto.builder()
                .protocol(this.properties.getProtocol())
                .protocolVersion(this.properties.getProtocolVersion())
                .serviceIdentity(this.properties.getServiceIdentityUrl())
                .privacyUrl(this.properties.getPrivacyUrl())
                .token(this.accessTokenService.buildAccessToken(subject))
                .consent(this.properties.getConsent())
                .subject(subject)
                .serviceProvider(this.properties.getServiceProvider())
                .build();
    }
}
