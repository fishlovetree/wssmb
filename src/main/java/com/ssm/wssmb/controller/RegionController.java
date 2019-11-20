package com.ssm.wssmb.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.plaf.basic.BasicTreeUI.TreeCancelEditingAction;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.ssm.wssmb.model.Region;
import com.ssm.wssmb.model.TreeNode;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.RegionService;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.TreeNodeLevel;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping(value = "/region")
public class RegionController {

	@Resource
	private RegionService regionService;

	@Resource
	private CommonTreeService commonTreeService;

	@Resource
	private UntilService untilService;

	@RequestMapping(value = "/index")
	@RequiresPermissions("region:index")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/Region");
		return mv;
	}

	/**
	 * @Description 获取区域树列表
	 * @return
	 * @throws Exception
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	@RequestMapping(value = "/regionTreeGrid", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<Map<String, Object>> regionTreeGrid(Integer regionid) throws Exception {
		return regionService.getRegionTreeGrid(regionid == null ? 0 : regionid);
	}

	/**
	 * @Description 获取区域列表
	 * @return
	 * @throws Exception
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@RequestMapping(value = "/regionDataGrid", produces = "text/html;charset=UTF-8;")
	public @ResponseBody String regionDataGrid(HttpServletRequest req, String regionName, int page, int rows)
			throws Exception {
		List<Region> list = regionService.getRegionList(regionName, (page - 1) * rows + 1, page * rows);
		int count = regionService.getRegionsCount(regionName);
		return untilService.getDataPager(list, count);
	}

	/**
	 * @Description 获取组织机构树
	 * @return
	 * @throws Exception
	 * @Time 2019年1月9日
	 * @Author dj
	 * @type 后端方法
	 */
	@RequestMapping(value = "/regionTree", produces = "application/json;charset=UTF-8;")
	public @ResponseBody List<TreeNode> regionTree(HttpServletRequest req, HttpServletResponse response)
			throws Exception {
		User user = (User) req.getSession(true).getAttribute("user");
		List<TreeNode> regionMapList = commonTreeService.getRegionTree(user.getOrganizationcode(), TreeNodeLevel.Area);
		return regionMapList;
	}

	/**
	 * @Description 添加区域
	 * @param region
	 * @return
	 * @throws Exception
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	@RequestMapping(value = "/addRegion", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String addRegion(Region region) throws Exception {
		if (region.getParentid() == null)
			region.setParentid(0);
		return regionService.addRegion(region);
	}

	/**
	 * @Description 编辑区域
	 * @param region
	 * @return
	 * @throws Exception
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	@RequestMapping(value = "/editRegion", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String editRegion(Region region) throws Exception {
		return regionService.editRegion(region);
	}

	/**
	 * @Description 通过id删除区域
	 * @param id
	 * @return
	 * @throws Exception
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	@RequestMapping(value = "/deleteRegion", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String deleteRegion(int id) throws Exception {
		return regionService.deleteRegion(id);
	}

	/**
	 * @Description 通过id选择区域
	 * @param regionid
	 * @return
	 * @throws Exception
	 * @Time 2018年7月12日
	 * @Author jiym
	 */
	@RequestMapping(value = "/selectRegionById", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String selectRegionById(int regionid) throws Exception {
		Region region = regionService.selectRegionById(regionid);
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		String json = gson.toJson(region);
		return json;
	}

	/**
	 * @Description 拾取区域范围页面
	 * @return
	 * @Time 2018年7月11日
	 * @Author jiym
	 */
	@RequestMapping(value = "/extentPick")
	public ModelAndView extentPick(String extent) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/extentPick");
		mv.addObject("extent", URLDecoder.decode(extent, "UTF-8"));
		return mv;
	}

	/**
	 * @Description 二维拾取设备坐标页面
	 * @return
	 * @Time 2018年4月21日
	 * @Author jiym
	 */
	@RequestMapping(value = "/coordsPick")
	public ModelAndView coordsPick(String coords) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("System/coordsPick2d");
		mv.addObject("coords", URLDecoder.decode(coords, "UTF-8"));
		return mv;
	}

	/**
	 * @Description 获取省直辖市
	 * @return
	 * @throws Exception
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@RequestMapping(value = "/getProvince", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getProvince() throws Exception {
		List<Region> list = regionService.selectProvince();
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		return gson.toJson(list);
	}

	/**
	 * @Description 根据省直辖市获取地级市
	 * @return
	 * @throws Exception
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@RequestMapping(value = "/getCity", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getCity(Integer provinceid) throws Exception {
		List<Region> list = regionService.selectCity(provinceid);
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		return gson.toJson(list);
	}

	/**
	 * @Description 根据地级市获取区县
	 * @return
	 * @throws Exception
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@RequestMapping(value = "/getCountry", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getCountry(Integer cityid) throws Exception {
		List<Region> list = regionService.selectCountry(cityid);
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		return gson.toJson(list);
	}

	/**
	 * 根据区县获得街道
	 * 
	 * @param cityid
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getStreet", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getStreet(Integer countryid) throws Exception {
		List<Region> list = regionService.selectStreet(countryid);
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		return gson.toJson(list);
	}

	/**
	 * 获取父级
	 * 
	 * @param leveltype
	 * @param id
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getPar", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String getPar(String leveltype, String id) throws Exception {
		Integer level = Integer.parseInt(leveltype);
		Integer iid = Integer.parseInt(id);
		Region stree = regionService.getPar(level, iid);
		Region country = regionService.getPar(level - 1, stree.getParentid());
		Region city = regionService.getPar(level - 2, country.getParentid());
		Region province = regionService.getPar(level - 3, city.getParentid());
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		Map<String, Region> list = new HashMap<String, Region>();
		list.put("stree", stree);
		list.put("country", country);
		list.put("city", city);
		list.put("province", province);
		String json = gson.toJson(list);
		return json;
	}

	@RequestMapping(value = "/selectByTwoDition", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String selectByTwoDition(String Leveltype, String id) throws Exception {
		Region region = regionService.selectByTwoDition(Integer.parseInt(Leveltype), Integer.parseInt(id));
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		return gson.toJson(region);
	}

}
