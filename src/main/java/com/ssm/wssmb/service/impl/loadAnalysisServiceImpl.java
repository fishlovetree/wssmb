package com.ssm.wssmb.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.LoadAnalysisMapper;
import com.ssm.wssmb.mapper.MbAmmeterMapper;
import com.ssm.wssmb.model.LoadAnalysis;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.service.loadAnalysisService;

@Service
public class loadAnalysisServiceImpl implements loadAnalysisService {

	@Autowired
	LoadAnalysisMapper loadMapper;

	@Resource
	private UntilService untilService;
	
	@Autowired
	MbAmmeterMapper ammeterMapper;

	/**
	 * 负荷分析
	 */
	@Override
	public String loadData(Integer id, String startdate, String enddate, int startindex, int endindex)
			throws Exception {
		List<LoadAnalysis> list = new ArrayList<LoadAnalysis>();
		List<LoadAnalysis> lists = new ArrayList<LoadAnalysis>();
		List<String> strlist = new ArrayList<String>();
		strlist = loadMapper.getAllType();
		List<MbAmmeter> ammeters = ammeterMapper.selectByIdAndType(id);
		String address = ammeters.get(0).getAmmeterCode();
		for(int i=0;i<strlist.size();i++) {
			list = loadMapper.getLoadAnalysis(address, startdate, enddate,strlist.get(i));
			lists.addAll(list);
		}		
		int count = lists.size();
		String json = untilService.getDataPager(lists, count);
		return json;
	}

	@Override
	public String powerAnalysis(Integer id, String startdate, String enddate) throws Exception {
		List<LoadAnalysis> list = new ArrayList<LoadAnalysis>();
		List<LoadAnalysis> lists = new ArrayList<LoadAnalysis>();
		List<String> strlist = new ArrayList<String>();
		strlist = loadMapper.getAllType();
		List<MbAmmeter> ammeters = ammeterMapper.selectByIdAndType(id);
		String address = ammeters.get(0).getAmmeterCode();
		for(int i=0;i<strlist.size();i++) {
		list = loadMapper.getLoadAnalysis(address, startdate, enddate,strlist.get(i));
		lists.addAll(list);
		}
		int count = lists.size();
		String json = untilService.getDataPager(lists, count);
		
		return json;
	}

}
