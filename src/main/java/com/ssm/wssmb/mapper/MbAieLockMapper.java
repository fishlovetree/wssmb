package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.MbAieLock;

public interface MbAieLockMapper {

	public List<MbAieLock> selectAll(@Param("organizationId") int organizationId, @Param("startin") int startin,
			@Param("endindex") int endindex);

	public List<MbAieLock> queryAieLockByBoxCode(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue, @Param("startin") int startin, @Param("endindex") int endindex);

	public List<MbAieLock> queryAieLockByLockCode(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue, @Param("startin") int startin, @Param("endindex") int endindex);

	public int addAieLock(MbAieLock mbAieLock);

	public boolean editAieLock(MbAieLock mbAieLock);

	public boolean addOneAieLock(MbAieLock mbAieLock);

	public boolean deleteAieLock(int id);

	public List<Integer> queryTotal(@Param("organizationId") int organizationId);

	public List<Integer> queryTotalByBox(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue);

	public List<Integer> queryTotalByLock(@Param("organizationId") int organizationId,
			@Param("inputValue") String inputValue);

	public List<MbAieLock> getAieLockByBoxCode(@Param("measureId") int measureId);

	public MbAieLock getLockByName(@Param("lockName") String lockName);

	public MbAieLock getLockByNameAndId(@Param("lockName") String lockName, @Param("id") int id);

	public MbAieLock getLockByMac(@Param("mac") String mac);

	// 更改e锁开关状态
	int changeOpenStatus(@Param(value = "openStatus") int openStatus, @Param(value = "id") int id);
}
