package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.OrganizationMapper;
import com.ssm.wssmb.mapper.TerminalMapper;
import com.ssm.wssmb.mapper.ViewEquipmentMapper;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.OrgAndCustomer;
import com.ssm.wssmb.model.Organization;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.model.ViewEquipment;
import com.ssm.wssmb.service.ViewEquipmentService;
import com.ssm.wssmb.util.TreeNodeType;

@Service
public class ViewEquipmentServiceImpl implements ViewEquipmentService {

	@Autowired
	TerminalMapper terminalMapper;

	@Autowired
	MbAmmeterMapper ammeterMapper;

	@Resource
	private ViewEquipmentMapper view_EquipmentMapper;

	/**
	 * @Description 通过设备id或设备地址获取设备（唯一）
	 * @param equipmentid      设备id
	 * @param equipmentaddress 设备地址
	 * @return
	 * @Time 2018年12月18日
	 * @Author dj
	 */
	@Override
	public List<ViewEquipment> selectByIdOrAddr(Integer equipmentid, String equipmentaddress) {
		return view_EquipmentMapper.selectByIdOrAddr(equipmentid, equipmentaddress);
	}

	/**
	 * @Description 通过设备ids设备列表(档案管理-下发档案)
	 * @param 设备ID
	 * @return 设备列表
	 * @Time 2018年12月26日
	 * @Author dj
	 */
	@Override
	public List<Terminal> getTerminalListByIDs(String[] ids) {
		if (ids.length > 0)
			return terminalMapper.getTerminalListByIDs(ids);
		else
			return new ArrayList<Terminal>();
	}

	@Override
	public List<MbAmmeter> getAmmeterlListByIDs(String[] ids) {
		if (ids.length > 0)
			return ammeterMapper.getAmmeterListByIDs(ids);
		else
			return new ArrayList<MbAmmeter>();
	}

}
