package com.ssm.wssmb.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.BusFreezedataMapper;
import com.ssm.wssmb.mapper.ConcentratorMapper;
import com.ssm.wssmb.mapper.MbAieLockMapper;
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.MbBlueBreakerMapper;
import com.ssm.wssmb.mapper.MeasureFileMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.Elecrealtimefreezedata;
import com.ssm.wssmb.model.MbAieLock;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.MbBlueBreaker;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.service.VirtualBoxService;

@Service
public class VirtualBoxServiceImpl implements VirtualBoxService {
	@Autowired
	public MeasureFileMapper measureFileMapper;
	
	@Autowired
	public ConcentratorMapper concentratorMapper;
	
	@Autowired
	public TerminalMapper terminalMapper;
	
	@Autowired
	public MbAmmeterMapper mbAmmeterMapper;
	
	@Autowired
	public MbAieLockMapper mbAieLockMapper;
	
	@Autowired
	public MbBlueBreakerMapper mbBlueBreakerMapper;
	
	@Autowired
	public BusFreezedataMapper busFreezedataMapper;
	
	/**
	 * 根据表箱ID获取表箱信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@Override
	public MeasureFile getBoxByBoxId(Integer boxId) {
		return measureFileMapper.getMeasurefileByMeasureId(boxId);
	}

	/**
	 * 根据表箱ID获取电表信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@Override
	public List<MbAmmeter> getAmmeterByBoxId(Integer boxId) {
		return mbAmmeterMapper.getAmmeterByMeasurefile(boxId.toString());
	}
	
	/**
	 * 根据表箱ID获取e锁信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@Override
	public List<MbAieLock> getElockByBoxId(Integer boxId) {
		return mbAieLockMapper.getAieLockByBoxCode(boxId);
	}
	
	/**
	 * 根据表箱ID获取集中器信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@Override
	public List<Concentrator> getConcentratorByBoxId(Integer boxId) {
		return concentratorMapper.getConcentratorByMeasureId(boxId);
	}
	
	/**
	 * 根据表箱ID获取监测终端信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@Override
	public List<Terminal> getTerminalByBoxId(Integer boxId) {
		return terminalMapper.getTerminalByMeasureId(boxId);
	}
	
	/**
	 * 根据表箱ID获取蓝牙断路器信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@Override
	public List<MbBlueBreaker> getBreakerByBoxId(Integer boxId) {
		return mbBlueBreakerMapper.getBlueBreakerByMeasureId(boxId);
	}
	
	/**
	 * 根据电表地址获取电表数据
	 * 
	 * @param meterAddr 表地址
	 * @return
	 * @author hxl
	 * @Time 2019年10月9号
	 */
	@Override
	public String getMeterData(String meterAddr) {
		return busFreezedataMapper.getRealtimePsitiveelectricity(meterAddr);
	}
	
	/**
	 * 根据监测终端地址获取终端数据
	 * 
	 * @param terminalAddr 监测终端地址
	 * @return
	 * @author hxl
	 * @Time 2019年10月11号
	 */
	@Override
	public Elecrealtimefreezedata getTerminalData(String terminalAddr) {
		return busFreezedataMapper.getTerminalDataForVirtual(terminalAddr);
	}
}
