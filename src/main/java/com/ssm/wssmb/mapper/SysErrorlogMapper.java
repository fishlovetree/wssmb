package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.OrgAndCustomer;
import com.ssm.wssmb.model.SysErrorlog;

public interface SysErrorlogMapper {
    int deleteByPrimaryKey(Integer logid);

    int insert(SysErrorlog record);

    int insertSelective(SysErrorlog record);

    SysErrorlog selectByPrimaryKey(Integer logid);

    int updateByPrimaryKeySelective(SysErrorlog record);

    int updateByPrimaryKey(SysErrorlog record);
    
    List<SysErrorlog> selectLogs(    		
    		@Param("orglist") List<OrgAndCustomer> orglist,
    		@Param("user") String user,
    		@Param("starttime")  String starttime,
    		@Param("endtime")  String endtime,
    		@Param("startin") int startin,
    		@Param("endindex") int endindex);
    
    int selectLogsCount(    		
    		@Param("orglist") List<OrgAndCustomer> orglist,
    		@Param("user") String user,
    		@Param("starttime")  String starttime,
    		@Param("endtime")  String endtime);
}