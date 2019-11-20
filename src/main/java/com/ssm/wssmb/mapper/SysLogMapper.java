package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.OrgAndCustomer;
import com.ssm.wssmb.model.SysLog;
import com.ssm.wssmb.model.User;

public interface SysLogMapper {
	int deleteByPrimaryKey(Integer logid);

	int insert(SysLog record);

	int insertSelective(SysLog record);

	SysLog selectByPrimaryKey(Integer logid);

	int updateByPrimaryKeySelective(SysLog record);

	int updateByPrimaryKey(SysLog record);

	List<SysLog> selectLogs(@Param("orglist") List<OrgAndCustomer> orglist, @Param("user") String user,
			@Param("starttime") String starttime, @Param("endtime") String endtime, @Param("keyword") String keyword,
			@Param("operatetype") String operatetype, @Param(value = "organizationcode") String organizationcode,
			@Param("startin") int startin, @Param("endindex") int endindex);

	int selectLogsCount(@Param("orglist") List<OrgAndCustomer> orglist, @Param("user") String user,
			@Param("starttime") String starttime, @Param("endtime") String endtime, @Param("keyword") String keyword,
			@Param("operatetype") String operatetype, @Param(value = "organizationcode") String organizationcode);

	List<SysLog> selectExportLogs(@Param("orglist") List<OrgAndCustomer> orglist, @Param("user") String user,
			@Param("starttime") String starttime, @Param("endtime") String endtime, @Param("keyword") String keyword,
			@Param("operatetype") String operatetype, @Param(value = "organizationcode") String organizationcode);

	/**
	 * 根据树节点类型和id获取日志集合
	 * 
	 * @return
	 */
	List<SysLog> getLogListByIdAndType(@Param("userlist") List<User> userlist, @Param("keyword") String keyword,
			@Param("starttime") String starttime, @Param("endtime") String endtime,
			@Param("operatetype") String operatetype, @Param("startindex") Integer startindex,
			@Param("endindex") Integer endindex);
	
	/**
	 * 根据树节点类型和id获取日志集合
	 * 
	 * @return
	 */
	int getLogCountByIdAndType(@Param("userlist") List<User> userlist, @Param("keyword") String keyword,
			@Param("starttime") String starttime, @Param("endtime") String endtime,
			@Param("operatetype") String operatetype);
}