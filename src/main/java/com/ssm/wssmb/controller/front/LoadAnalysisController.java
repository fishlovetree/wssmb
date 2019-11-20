package com.ssm.wssmb.controller.front;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.controller.CommonMethod;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.redis.RedisService;
import com.ssm.wssmb.service.loadAnalysisService;

@Controller
@RequestMapping(value = "/load")
public class LoadAnalysisController {
	
	@Autowired
	loadAnalysisService loadService;

	// 读取配置文件中的语言信息
	@Value("${language}")
	private String mlanguage;

	// 读取配置文件中的版本号
	@Value("${version}")
	private String mversion;

	// 读取配置文件中的websocketip
	@Value("${websocketip}")
	private String websocketip;
	// 读取配置文件中的websocketport
	@Value("${websocketport}")
	private String websocketport;

	/**
	 * @Description 前台系统-非侵入式负荷分析
	 * @return
	 * @Time 2019年10月5日
	 * @Author rcd
	 */
	// @RequiresPermissions("analysis")
	@RequestMapping(value = "/analysis")
	public ModelAndView analysis() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("Front/NoninvasiveLoadAnalysis/index");
		return mv;
	}

	/**
	 * @Description 前台系统-非侵入式符合分析tab页面加载
	 * @param
	 * @return
	 * @Time 2019年10月47日
	 * @Author rcd
	 */
	@RequestMapping(value = "/loadtype")
	public ModelAndView loadtype(String type, HttpServletRequest req) {
		ModelAndView mv = new ModelAndView();
		String viewName = "";
		switch (type) {	
		case "load":
			viewName = "Front/NoninvasiveLoadAnalysis/load";
			break;
		case "elec":
			viewName = "Front/NoninvasiveLoadAnalysis/elec";
			break;		
		default:
			viewName = "Front/NoninvasiveLoadAnalysis/load";
			break;
		}
		mv.setViewName(viewName);
		return mv;
	}
	
	/**
	 * 负荷分析
	 * @return
	 * @throws Exception
	 * rcd  2019/10/8
	 */
	@RequestMapping(value = "/loaddata", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String loaddata(HttpServletRequest re, Integer id, String startdate,
			String enddate, int page, int rows) throws Exception {
		return loadService.loadData(id,  startdate, enddate,(page - 1) * rows + 1, page * rows);
	}
	
	/**
	 * 负荷分析
	 * @return
	 * @throws Exception
	 * rcd  2019/10/9
	 */
	@RequestMapping(value = "/powerAnalysis", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String powerAnalysis(HttpServletRequest re, Integer id, String startdate,
			String enddate, int page, int rows) throws Exception {
		return loadService.powerAnalysis(id,  startdate, enddate);
	}
}
