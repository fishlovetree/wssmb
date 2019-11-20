package com.ssm.wssmb.controller;

import java.net.URLDecoder;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.Region;
import com.ssm.wssmb.service.RegionService;

/**
 * @Description: 用户档案
 * @Author dj
 * @Time: 2018年1月11号
 */
@Controller
@RequestMapping(value="/sysCustomerFile")
public class CustomerFileController {
	
	
	@Resource
	private RegionService regionService;
	
	//读取配置文件中的websocketip
	@Value("${websocketip}") 
	private String websocketip;
	
	//读取配置文件中的websocketport
	@Value("${websocketport}") 
	private String websocketport;
	
	
	/**
	 * @Description 二维拾取设备坐标页面
	 * @param coords 修改状态下的原来的坐标
	 * @param regionid 已选的行政区域id
	 * @param cityname 已选的城市名称（用于检索定位）
	 * @return
	 * @Time 2018年4月21日
	 * @Author jiym
	 */
	@RequestMapping(value="/coordsPick")
	public ModelAndView coordsPick(String coords,int regionid,String cityname) throws Exception{
		ModelAndView mv = new ModelAndView();
		mv.setViewName("CustomerDevice/coordsPick2d");
		Region region = regionService.selectRegionById(regionid);
		mv.addObject("coords",URLDecoder.decode(coords, "UTF-8"));
		mv.addObject("cityname",URLDecoder.decode(cityname, "UTF-8"));
		if(region != null){
			mv.addObject("regionCenter","["+region.getLng()+","+region.getLat()+"]"); //区域中心点经纬度
		}
		return  mv;
	}
	
}
