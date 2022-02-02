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

package eu.europa.ec.dgc.validation.decorator.converter;

import eu.europa.ec.dgc.validation.decorator.dto.ResultToken;
import eu.europa.ec.dgc.validation.decorator.dto.ResultToken.Result;
import eu.europa.ec.dgc.validation.decorator.entity.ServiceResultRequest;
import eu.europa.ec.dgc.validation.decorator.entity.ServiceResultRequest.DccStatusRequest;
import eu.europa.ec.dgc.validation.decorator.entity.ServiceResultRequest.ResultRequest;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Service;

@Service
public class ResultTokenToServiceResultRequestConverter implements Converter<ResultToken, ServiceResultRequest> {

    @Override
    public ServiceResultRequest convert(ResultToken source) {
        final ServiceResultRequest request = new ServiceResultRequest();
        request.setDccStatus(new DccStatusRequest());
        request.getDccStatus().setIssuer(source.getIssuer());
        request.getDccStatus().setIat(source.getIat());

        if (source.getResults() != null) {
            final List<ResultRequest> resultsRequest = source.getResults().stream()
                    .map(this::convert)
                    .collect(Collectors.toList());
            request.getDccStatus().setResults(resultsRequest);
        }
        return request;
    }

    private ResultRequest convert(Result result) {
        final ResultRequest resultRequest = new ResultRequest();
        resultRequest.setIdentifier(result.getIdentifier());
        resultRequest.setResult(result.getResult());
        resultRequest.setType(result.getType());
        resultRequest.setDetails(result.getDetails());
        return resultRequest;
    }
}
