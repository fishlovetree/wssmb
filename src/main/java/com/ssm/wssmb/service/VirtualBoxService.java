package com.ssm.wssmb.service;

import java.util.List;

import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.Elecrealtimefreezedata;
import com.ssm.wssmb.model.MbAieLock;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.MbBlueBreaker;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Terminal;

public interface VirtualBoxService {

	/**
	 * 根据表箱ID获取表箱信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	MeasureFile getBoxByBoxId(Integer boxId);

	/**
	 * 根据表箱ID获取电表信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	List<MbAmmeter> getAmmeterByBoxId(Integer boxId);
	
	/**
	 * 根据表箱ID获取e锁信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	List<MbAieLock> getElockByBoxId(Integer boxId);
	
	/**
	 * 根据表箱ID获取集中器信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	List<Concentrator> getConcentratorByBoxId(Integer boxId);
	
	/**
	 * 根据表箱ID获取监测终端信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	List<Terminal> getTerminalByBoxId(Integer boxId);
	
	/**
	 * 根据表箱ID获取蓝牙断路器信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	List<MbBlueBreaker> getBreakerByBoxId(Integer boxId);
	
	/**
	 * 根据电表地址获取电表数据
	 * 
	 * @param meterAddr 表地址
	 * @return
	 * @author hxl
	 * @Time 2019年10月9号
	 */
	String getMeterData(String meterAddr);
	
	/**
	 * 根据监测终端地址获取终端数据
	 * 
	 * @param terminalAddr 监测终端地址
	 * @return
	 * @author hxl
	 * @Time 2019年10月11号
	 */
	 Elecrealtimefreezedata getTerminalData(String terminalAddr);
}
