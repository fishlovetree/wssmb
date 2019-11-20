package com.ssm.wssmb.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.AmmeterStatusMapper;
import com.ssm.wssmb.model.AmmeterStatus;
import com.ssm.wssmb.service.EquipmentStatusService;

@Service
public class EquipmentStatusimpl implements EquipmentStatusService {

	@Autowired
	AmmeterStatusMapper ammeterStatusMapper;

	@Override
	public List<AmmeterStatus> getAmmeterStatus(Integer orgId, Integer id, Integer type, Integer onlinestatus)
			throws Exception {
		List<AmmeterStatus> list = new ArrayList<AmmeterStatus>();
		List<AmmeterStatus> onlinelist = new ArrayList<AmmeterStatus>();
		List<AmmeterStatus> offlist = new ArrayList<AmmeterStatus>();
		if (id == null || id == 0) {
			list = ammeterStatusMapper.getAllAmmeter(orgId);
			for (int i = 0; i < list.size(); i++) {
				int ammeterid = list.get(i).getId();
				// 获取最近冻结时间
				String lastFreezeTime = ammeterStatusMapper.getLastFreezeTimeByAmmeterId(list.get(i).getAmmeterCode());
				list.get(i).setLastFreezeTime(lastFreezeTime);
				// 获取最近告警时间
				String lastEarlyWarnTime = ammeterStatusMapper.getLastEarlyWarnTimeByAmmeterId(ammeterid);
				list.get(i).setLastEarlyWarnTime(lastEarlyWarnTime);
				if (lastFreezeTime != null) {
					// 判断冻结时间是否是在一天内
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date freezing = sdf.parse(lastFreezeTime);
					Date now = new Date();
					long timecha = now.getTime() - freezing.getTime();
					if (timecha <= 172800000) {// 时间差在一天之内
						list.get(i).setStatus(1);
						onlinelist.add(list.get(i));
					} else {
						list.get(i).setStatus(0);
						offlist.add(list.get(i));
					}
				} else {
					list.get(i).setStatus(0);
					offlist.add(list.get(i));
				}
			}
		} else {// 树节点为组织机构、表箱、集中器、电表
			if (type == 1 || type == 3 || type == 4 || type == 6) {
				list = ammeterStatusMapper.getAmmeterStatusById(id, type);
				for (int i = 0; i < list.size(); i++) {
					int ammeterid = list.get(i).getId();
					// 获取最近冻结时间
					String lastFreezeTime = ammeterStatusMapper.getLastFreezeTimeByAmmeterId(list.get(i).getAmmeterCode());
					list.get(i).setLastFreezeTime(lastFreezeTime);
					// 获取最近告警时间
					String lastEarlyWarnTime = ammeterStatusMapper.getLastEarlyWarnTimeByAmmeterId(ammeterid);
					list.get(i).setLastEarlyWarnTime(lastEarlyWarnTime);
					if (lastFreezeTime != null) {
						// 判断冻结时间是否是在一天内
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date freezing = sdf.parse(lastFreezeTime);
						Date now = new Date();
						long timecha = now.getTime() - freezing.getTime();
						if (timecha <= 172800000) {// 时间差在一天之内
							list.get(i).setStatus(1);
							onlinelist.add(list.get(i));
						} else {
							list.get(i).setStatus(0);
							offlist.add(list.get(i));
						}
					} else {
						list.get(i).setStatus(0);
						offlist.add(list.get(i));
					}
				}
			} else {// 树节点为区域
				list = ammeterStatusMapper.getAmmeterByRegion(orgId, id);
				for (int i = 0; i < list.size(); i++) {
					int ammeterid = list.get(i).getId();
					// 获取最近冻结时间
					String lastFreezeTime = ammeterStatusMapper.getLastFreezeTimeByAmmeterId(list.get(i).getAmmeterCode());
					list.get(i).setLastFreezeTime(lastFreezeTime);
					// 获取最近告警时间
					String lastEarlyWarnTime = ammeterStatusMapper.getLastEarlyWarnTimeByAmmeterId(ammeterid);
					list.get(i).setLastEarlyWarnTime(lastEarlyWarnTime);
					
					if (lastFreezeTime != null) {
						// 判断冻结时间是否是在一天内
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date freezing = sdf.parse(lastFreezeTime);
						Date now = new Date();
						long timecha = now.getTime() - freezing.getTime();
						if (timecha <= 172800000) {// 时间差在一天之内
							list.get(i).setStatus(1);
							onlinelist.add(list.get(i));
						} else {
							list.get(i).setStatus(0);
							offlist.add(list.get(i));
						}
					} else {
						list.get(i).setStatus(0);
						offlist.add(list.get(i));
					}
				}
			}
		}
		if (onlinestatus == null) {
			return list;
		} else if (onlinestatus == 1) {
			return onlinelist;
		} else {
			return offlist;
		}
	}

	@Override
	public List<AmmeterStatus> getTerminalStatus(Integer orgId, Integer id, Integer type, Integer onlinestatus)
			throws Exception {
		List<AmmeterStatus> list = new ArrayList<AmmeterStatus>();
		List<AmmeterStatus> onlinelist = new ArrayList<AmmeterStatus>();
		List<AmmeterStatus> offlist = new ArrayList<AmmeterStatus>();
		if (id == null || id == 0) {
			list = ammeterStatusMapper.getAllTerminal(orgId);
			for (int i = 0; i < list.size(); i++) {
				int terminalId = list.get(i).getId();
				// 获取最近冻结时间
				String lastFreezeTime = ammeterStatusMapper.getLastFreezeTimeByTerminalId(list.get(i).getAmmeterCode());
				list.get(i).setLastFreezeTime(lastFreezeTime);
				// 获取最近告警时间
				String lastEarlyWarnTime = ammeterStatusMapper.getLastEarlyWarnTimeByTerminalId(terminalId);
				list.get(i).setLastEarlyWarnTime(lastEarlyWarnTime);
				
				if (lastFreezeTime != null) {
					// 判断冻结时间是否是在一天内
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date freezing = sdf.parse(lastFreezeTime);
					Date now = new Date();
					long timecha = now.getTime() - freezing.getTime();
					if (timecha <= 172800000) {// 时间差在一天之内
						list.get(i).setStatus(1);
						onlinelist.add(list.get(i));
					} else {
						list.get(i).setStatus(0);
						offlist.add(list.get(i));
					}
				} else {
					list.get(i).setStatus(0);
					offlist.add(list.get(i));
				}
			}
		} else {// 树节点为组织机构、表箱、集中器、终端
			if (type == 1 || type == 3 || type == 4 || type == 5) {
				list = ammeterStatusMapper.getTerminalStatusById(id, type);
				for (int i = 0; i < list.size(); i++) {
					int ammeterid = list.get(i).getId();
					// 获取最近冻结时间
					String lastFreezeTime = ammeterStatusMapper.getLastFreezeTimeByTerminalId(list.get(i).getAmmeterCode());
					list.get(i).setLastFreezeTime(lastFreezeTime);
					// 获取最近告警时间
					String lastEarlyWarnTime = ammeterStatusMapper.getLastEarlyWarnTimeByTerminalId(ammeterid);
					list.get(i).setLastEarlyWarnTime(lastEarlyWarnTime);
					
					if (lastFreezeTime != null) {
						// 判断冻结时间是否是在一天内
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date freezing = sdf.parse(lastFreezeTime);
						Date now = new Date();
						long timecha = now.getTime() - freezing.getTime();
						if (timecha <= 172800000) {// 时间差在一天之内
							list.get(i).setStatus(1);
							onlinelist.add(list.get(i));
						} else {
							list.get(i).setStatus(0);
							offlist.add(list.get(i));
						}
					} else {
						list.get(i).setStatus(0);
						offlist.add(list.get(i));
					}
				}
			} else {// 树节点为区域
				list = ammeterStatusMapper.getTerminalByRegion(orgId, id);
				for (int i = 0; i < list.size(); i++) {
					int ammeterid = list.get(i).getId();
					// 获取最近冻结时间
					String lastFreezeTime = ammeterStatusMapper.getLastFreezeTimeByTerminalId(list.get(i).getAmmeterCode());
					list.get(i).setLastFreezeTime(lastFreezeTime);
					// 获取最近告警时间
					String lastEarlyWarnTime = ammeterStatusMapper.getLastEarlyWarnTimeByTerminalId(ammeterid);
					list.get(i).setLastEarlyWarnTime(lastEarlyWarnTime);
					
					if (lastFreezeTime != null) {
						// 判断冻结时间是否是在一天内
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date freezing = sdf.parse(lastFreezeTime);
						Date now = new Date();
						long timecha = now.getTime() - freezing.getTime();
						if (timecha <= 172800000) {// 时间差在一天之内
							list.get(i).setStatus(1);
							onlinelist.add(list.get(i));
						} else {
							list.get(i).setStatus(0);
							offlist.add(list.get(i));
						}
					} else {
						list.get(i).setStatus(0);
						offlist.add(list.get(i));
					}
				}
			}
		}
		if (onlinestatus == null) {
			return list;
		} else if (onlinestatus == 1) {
			return onlinelist;
		} else {
			return offlist;
		}
	}

	@Override
	public List<AmmeterStatus> getConcentratorStatus(Integer orgId, Integer id, Integer type, Integer onlinestatus)
			throws Exception {
		List<AmmeterStatus> list = new ArrayList<AmmeterStatus>();
		List<AmmeterStatus> onlinelist = new ArrayList<AmmeterStatus>();
		List<AmmeterStatus> offlist = new ArrayList<AmmeterStatus>();
		if (id == null || id == 0) {
			list = ammeterStatusMapper.getAllConcentrator(orgId);
			for (int i = 0; i < list.size(); i++) {
				int concentratorId = list.get(i).getId();
				// 获取在线时间、离线时间、状态
				AmmeterStatus concentratosSatatus = ammeterStatusMapper.getOnlineTimeByConcentratorId(concentratorId);
				if (concentratosSatatus==null) {
					list.get(i).setOnlineTime(null);
					list.get(i).setOfflineTime(null);
					list.get(i).setStatus(null);
				}else {
					list.get(i).setOnlineTime(concentratosSatatus.getOnlineTime());
					list.get(i).setOfflineTime(concentratosSatatus.getOfflineTime());
					list.get(i).setStatus(concentratosSatatus.getStatus());
					if (concentratosSatatus.getStatus() == 0) {
						offlist.add(list.get(i));
					} else {
						onlinelist.add(list.get(i));
					}
				}						
			}
		} else {// 树节点为组织机构、表箱、集中器
			if (type == 1 || type == 3 || type == 4) {
				list = ammeterStatusMapper.getConcentratorStatusById(id, type);
				for (int i = 0; i < list.size(); i++) {
					int concentratorId = list.get(i).getId();
					AmmeterStatus concentratosSatatus = ammeterStatusMapper
							.getOnlineTimeByConcentratorId(concentratorId);
					if (concentratosSatatus==null) {
						list.get(i).setOnlineTime(null);
						list.get(i).setOfflineTime(null);
						list.get(i).setStatus(null);
					}else {
					list.get(i).setOnlineTime(concentratosSatatus.getOnlineTime());
					list.get(i).setOfflineTime(concentratosSatatus.getOfflineTime());
					list.get(i).setStatus(concentratosSatatus.getStatus());
					if (concentratosSatatus.getStatus() == 0) {
						offlist.add(list.get(i));
					} else {
						onlinelist.add(list.get(i));
					}
					}
				}
			} else {// 树节点为区域
				list = ammeterStatusMapper.getConcentratorByRegion(orgId, id);
				for (int i = 0; i < list.size(); i++) {
					int concentratorId = list.get(i).getId();
					AmmeterStatus concentratosSatatus = ammeterStatusMapper
							.getOnlineTimeByConcentratorId(concentratorId);
					if (concentratosSatatus==null) {
						list.get(i).setOnlineTime(null);
						list.get(i).setOfflineTime(null);
						list.get(i).setStatus(null);
					}else {
					list.get(i).setOnlineTime(concentratosSatatus.getOnlineTime());
					list.get(i).setOfflineTime(concentratosSatatus.getOfflineTime());
					list.get(i).setStatus(concentratosSatatus.getStatus());
					if (concentratosSatatus.getStatus() == 0) {
						offlist.add(list.get(i));
					} else {
						onlinelist.add(list.get(i));
					}
					}
				}
			}
		}
		if (onlinestatus == null) {
			return list;
		} else if (onlinestatus == 1) {
			return onlinelist;
		} else {
			return offlist;
		}
	}

}
