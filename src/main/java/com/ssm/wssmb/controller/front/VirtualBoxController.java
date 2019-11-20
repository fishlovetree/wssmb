package com.ssm.wssmb.controller.front;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.Concentrator;
import com.ssm.wssmb.model.Elecrealtimefreezedata;
import com.ssm.wssmb.model.MbAieLock;
import com.ssm.wssmb.model.MbAmmeter;
import com.ssm.wssmb.model.MbBlueBreaker;
import com.ssm.wssmb.model.MeasureFile;
import com.ssm.wssmb.model.Terminal;
import com.ssm.wssmb.service.VirtualBoxService;

/**
 * @Description:三维表箱
 * @Author hxl
 * @Time: 2019年9月27日
 */
@Controller
@RequestMapping(value = "/virtualBox")
public class VirtualBoxController {
	
	@Resource
	VirtualBoxService virualBoxService;

	/**
	 * @Description 三维表箱首页
	 * @param req
	 * @return
	 * @throws Exception
	 * @Time 2019-09-27
	 * @Author hxl
	 */
	@RequestMapping(value = "/index")
	public ModelAndView login(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/VirtualBox/index");
		return mv;
	}
	
	/**
	 * 根据表箱ID获取表箱信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@RequestMapping(value = "/getBoxByBoxId", produces = "application/json;charset=UTF-8;")
	public @ResponseBody MeasureFile getBoxByBoxId(Integer id) {
		return virualBoxService.getBoxByBoxId(id);
	}
	
	/**
	 * 根据表箱ID获取电表信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@RequestMapping(value = "/getAmmeterByBoxId", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<MbAmmeter> getAmmeterByBoxId(Integer id) {
		return virualBoxService.getAmmeterByBoxId(id);
	}
	
	/**
	 * 根据表箱ID获取e锁信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@RequestMapping(value = "/getElockByBoxId", produces = "application/json;charset=UTF-8;")
	public @ResponseBody MbAieLock getElockByBoxId(Integer id) {
		List<MbAieLock> elocks = virualBoxService.getElockByBoxId(id);
		if (null == elocks || elocks.size() == 0){
			return new MbAieLock();
		}
		return virualBoxService.getElockByBoxId(id).get(0); 
	}
	
	/**
	 * 根据表箱ID获取集中器信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@RequestMapping(value = "/getConcentratorByBoxId", produces = "application/json;charset=UTF-8;")
	public @ResponseBody Concentrator getConcentratorByBoxId(Integer id) {
		List<Concentrator> concentrators = virualBoxService.getConcentratorByBoxId(id);
		if (null == concentrators || concentrators.size() == 0){
			return new Concentrator();
		}
		return concentrators.get(0);
	}
	
	/**
	 * 根据表箱ID获取监测终端信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@RequestMapping(value = "/getTerminalByBoxId", produces = "application/json;charset=UTF-8;")
	public @ResponseBody Terminal getTerminalByBoxId(Integer id) {
		List<Terminal> terminals = virualBoxService.getTerminalByBoxId(id);
		if (null == terminals || terminals.size() == 0){
			return new Terminal();
		}
		return terminals.get(0);
	}
	
	/**
	 * 根据表箱ID获取蓝牙断路器信息
	 * 
	 * @param boxId 表箱id
	 * @return
	 * @author hxl
	 * @Time 2019年9月28号
	 */
	@RequestMapping(value = "/getBreakerByBoxId", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<MbBlueBreaker> getBreakerByBoxId(Integer id) {
		return virualBoxService.getBreakerByBoxId(id);
	}
	
	/**
	 * 根据电表地址获取电表数据
	 * 
	 * @param meterAddr 表地址
	 * @return
	 * @author hxl
	 * @Time 2019年10月9号
	 */
	@RequestMapping(value = "/getMeterData", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getMeterData(String meterAddr) {
		return virualBoxService.getMeterData(meterAddr);
	}
	
	/**
	 * 根据监测终端地址获取终端数据
	 * 
	 * @param terminalAddr 监测终端地址
	 * @return
	 * @author hxl
	 * @Time 2019年10月11号
	 */
	@RequestMapping(value = "/getTerminalData", produces = "application/json;charset=UTF-8;")
	public @ResponseBody Elecrealtimefreezedata getTerminalData(String terminalAddr) {
		return virualBoxService.getTerminalData(terminalAddr);
	}
}
