package com.ssm.wssmb.service.impl;

import java.util.List;
import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.model.EventThreshold;
import com.ssm.wssmb.redis.RedisService;
import com.ssm.wssmb.service.EventThresholdService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ws.apdu698.GetRequestNormal;
import com.ws.data698.OAD;
import com.ws.data698.PIID;

@Service
public class EventThresholdServiceImpl implements EventThresholdService {

	@Autowired
	RedisService redisService;

	@Resource
	private EventLogAspect log;

	@Override
	public List<String> getThreshold(EventThreshold record) throws Exception {
		Integer oi = record.getEventtypecode();
		switch (oi) {
		case 1:
			oi = 2001;
			break;

		default:
			break;
		}
		PIID piid = new PIID(0, 1);
		OAD oad = new OAD(oi.toString(), 0, 0);
		GetRequestNormal grnor = new GetRequestNormal(piid, oad);
		grnor.toString();
		Integer seq = (Integer) redisService.get("seq");
		if (seq == null) {
			seq = 1;
			redisService.set("seq", 1);
		}	
		if (seq > 1023) {			
			redisService.set("seq", 1);
			seq = 1;
		}	
		return null;
	}

	public String queryThreshold() {		
		return null;
	}

}
