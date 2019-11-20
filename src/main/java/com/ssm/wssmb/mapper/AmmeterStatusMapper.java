package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.AmmeterStatus;

public interface AmmeterStatusMapper {

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 获取所有电表
	List<AmmeterStatus> getAllAmmeter(@Param("orgId") Integer orgId);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据区域获取电表
	List<AmmeterStatus> getAmmeterByRegion(@Param("orgId") Integer orgId, @Param("id") Integer id);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据点击的树节点获取电表
	List<AmmeterStatus> getAmmeterStatusById(@Param("id") Integer id, @Param("type") Integer type);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据电表id获取最近冻结时间
	String getLastFreezeTimeByAmmeterId(@Param("address") String address);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据电表id获取最近告警时间
	String getLastEarlyWarnTimeByAmmeterId(@Param("id") Integer id);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据电表id获取最近故障时间
	String getLastFaultTimeByAmmeterId(@Param("id") Integer id);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 获取所有终端
	List<AmmeterStatus> getAllTerminal(@Param("orgId") Integer orgId);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据区域获取终端
	List<AmmeterStatus> getTerminalByRegion(@Param("orgId") Integer orgId, @Param("id") Integer id);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据点击的树节点获取终端
	List<AmmeterStatus> getTerminalStatusById(@Param("id") Integer id, @Param("type") Integer type);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据终端id获取最近冻结时间
	String getLastFreezeTimeByTerminalId(@Param("address") String address);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据终端id获取最近告警时间
	String getLastEarlyWarnTimeByTerminalId(@Param("id") Integer id);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据终端id获取最近故障时间
	String getLastFaultTimeByTerminalId(@Param("id") Integer id);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 获取所有集中器
	List<AmmeterStatus> getAllConcentrator(@Param("orgId") Integer orgId);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据区域获取集中器
	List<AmmeterStatus> getConcentratorByRegion(@Param("orgId") Integer orgId, @Param("id") Integer id);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据集中器id获取在线时间
	AmmeterStatus getOnlineTimeByConcentratorId(@Param("id") Integer id);

	/**
	 * 
	 * @param 
	 * @return
	 * rcd
	 */
	// 根据点击的树节点获取集中器
	List<AmmeterStatus> getConcentratorStatusById(@Param("id") Integer id, @Param("type") Integer type);

}
