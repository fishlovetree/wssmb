package com.ssm.wssmb.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.SysIdentityMapper;
import com.ssm.wssmb.model.SysIdentity;
import com.ssm.wssmb.service.SysIdentityService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.Operation;

@Service
public class SysIdentityServiceImpl implements SysIdentityService {

	@Resource
	private SysIdentityMapper identityMapper;
	
	@Resource
	private EventLogAspect log;
	
	@Override
	public int deleteByPrimaryKey(String identityname) {			
        String content = "流水名：" + identityname;
        log.addLog("", "删除流水", content, 1);
		return identityMapper.deleteByPrimaryKey(identityname);
	}

	@Override
	public int insert(SysIdentity record) {		
        String content = "流水名：" + record.getIdentityname() + "，流水值：" + record.getIdentityvalue();
        log.addLog("", "添加流水", content, 0);
		return identityMapper.insert(record);
	}

	@Override
	public int insertSelective(SysIdentity record) {		
		String content = "流水名：" + record.getIdentityname() + "，流水值：" + record.getIdentityvalue();
        log.addLog("", "添加流水", content, 0);
		return identityMapper.insertSelective(record);
	}

	@Override
	public SysIdentity selectByPrimaryKey(String identityname) {
		return identityMapper.selectByPrimaryKey(identityname);
	}

	@Override
	public int updateByPrimaryKeySelective(SysIdentity record) {		
		String content = "流水名：" + record.getIdentityname() + "，流水值：" + record.getIdentityvalue();
        log.addLog("", "更新流水", content, 2);
		return identityMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(SysIdentity record) {		
		String content = "流水名：" + record.getIdentityname() + "，流水值：" + record.getIdentityvalue();
        log.addLog("", "更新流水", content, 2);
		return identityMapper.updateByPrimaryKey(record);
	}

	@Override
	public long selectRow(String identityname) {
		SysIdentity identity=identityMapper.selectByPrimaryKey(identityname);
		long temp=1;
		
		SysIdentity record=new SysIdentity();
		if(null==identity){//无流水记录，则添加
			record.setIdentityname(identityname);
			record.setIdentitydescribing(identityname);
			record.setIdentityvalue((long)1);
			temp=identityMapper.insertSelective(record);
			temp=1;
		}
		else{//有流水记录，则更新+1
			record.setIdentityname(identityname);
			record.setIdentitydescribing(identityname);
			record.setIdentityvalue(identity.getIdentityvalue()+1);
			temp=identityMapper.updateByPrimaryKeySelective(record);
			temp=identity.getIdentityvalue()+1;
		}
		return temp;
	}
}
