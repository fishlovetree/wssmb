package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

/**
 * @Description: 三维可视化实时监控业务接口
 * @Author jiym
 * @Time: 2018年2月6日
 */
public interface VisualizationService {	
	
	String makeRealtimeFrame(Integer equipmentid, Integer userID,Integer type) throws Exception;
		
}
