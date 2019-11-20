package com.ssm.wssmb.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ssm.wssmb.model.Constant;
import com.ssm.wssmb.model.ConstantDetail;
import com.ssm.wssmb.service.ConstantService;

@Controller
@RequestMapping(value="/constant")
public class ConstantController {
    
	@Resource
	private ConstantService constantService;
	
	@RequestMapping(value="/index")
	@RequiresPermissions("constant:index")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/Constant");
		return  mv;
	}
	
	/**
	 * @Description 获取常量集合
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/getConstantList",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Constant> getConstantList(){
		return constantService.getConstantList();
	}
	
	/**
	 * @Description 获取常量子项集合
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/getDetailList",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<ConstantDetail> getDetailList(int coding){
		return constantService.getDetailList(coding);
	}
	
	/**
	 * @Description 获取常量子项集合
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/getDetailList_All",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<ConstantDetail> getDetailList_All(int coding){
		List<ConstantDetail> list = constantService.getDetailList(coding);
		ConstantDetail all = new ConstantDetail();
		all.setDetailvalue("");
		all.setDetailname("所有");
		list.add(0, all);
		return list;
	}
	
	/**
	 * @Description 添加常量
	 * @param constant
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/addConstant",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addConstant(Constant constant) throws Exception{
		return constantService.addConstant(constant);
	}

	/**
	 * @Description 编辑常量
	 * @param constant
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/editConstant",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String editConstant(Constant constant) throws Exception{
		return constantService.editConstant(constant);
	}

	/**
	 * @Description 通过coding删除常量
	 * @param coding
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/deleteConstant",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteConstant(int coding) throws Exception{
		return constantService.deleteConstant(coding);
	}
	
	/**
	 * @Description 添加常量子项
	 * @param constantDetail
	 * @return
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/addDetail",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addDetail(ConstantDetail constantDetail) throws Exception{
		return constantService.addDetail(constantDetail);
	}

	/**
	 * @Description 编辑常量子项
	 * @param constantDetail
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/editDetail",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String editDetail(ConstantDetail constantDetail) throws Exception{
		return constantService.editDetail(constantDetail);
	}

	/**
	 * @Description 通过id删除常量子项
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/deleteDetail",method=RequestMethod.POST,produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteDetail(int id) throws Exception{
		return constantService.deleteDetail(id);
	}
	
	/**
	 * @Description 常量树
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月12日
	 * @Author hxl
	 */
	@RequestMapping(value="/getTreeData",produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Map<String, Object>> getTreeData(){
		return constantService.getTreeData();
	}
}
