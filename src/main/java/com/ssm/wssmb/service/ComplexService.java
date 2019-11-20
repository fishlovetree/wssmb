package com.ssm.wssmb.service;

import java.util.Map;

public interface ComplexService {
	Map<String, Object> parseResponse(String strXML) throws Exception;
}
