package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.SysErrorlogMapper;
import com.ssm.wssmb.model.OrgAndCustomer;
import com.ssm.wssmb.model.SysErrorlog;
import com.ssm.wssmb.service.ErrorLogService;
@Service
public class ErrorLogServiceImpl implements ErrorLogService {

	@Resource
	private SysErrorlogMapper logMapper;
	
	@Resource
	private OrgAndCustomerMapper orgAndCustomerMapper;

	@Override
	public boolean insert(SysErrorlog log) throws Exception {
		int result = logMapper.insertSelective(log);
		if (result == 1) {
			return true;
		} else {
			return false;
		}

	}

	@Override
	public List<SysErrorlog> getLogList(String organization,String user,String starttime,String endtime,int startindex, int endindex) throws Exception {
		Integer startin=startindex-1;
		List<SysErrorlog> list = new ArrayList<SysErrorlog>();
		if(null==organization||""==organization){
			
			list = logMapper.selectLogs(null, user, starttime,endtime,startin,endindex);
		}else{
			List<OrgAndCustomer> orgAndCustomers = orgAndCustomerMapper.selectListByCode(organization);
			list = logMapper.selectLogs(orgAndCustomers, user, starttime,endtime,startin,endindex);
		}
		return list;
	}
	
	@Override
	public int getLogListCount(String organization,String user,String starttime,String endtime) throws Exception {
		int count;
		if(null==organization||""==organization){
			count = logMapper.selectLogsCount(null, user, starttime,endtime);
		}else{
			List<OrgAndCustomer> orgAndCustomers = orgAndCustomerMapper.selectListByCode(organization);
			count = logMapper.selectLogsCount(orgAndCustomers, user, starttime,endtime);
		}
		return count;
	}

	@Override
	public SysErrorlog getLogRow(Integer logid) throws Exception {
		SysErrorlog model = logMapper.selectByPrimaryKey(logid);
		return model;
	}
}