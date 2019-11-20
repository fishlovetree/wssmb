package com.ssm.wssmb.service;

import java.util.List;
import com.ssm.wssmb.model.EventThreshold;

public interface EventThresholdService {

	List<String> getThreshold(EventThreshold record) throws Exception;
    
}
