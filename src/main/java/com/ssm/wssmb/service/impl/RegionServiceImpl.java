package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.RegionMapper;
import com.ssm.wssmb.model.Region;
import com.ssm.wssmb.service.RegionService;
import com.ssm.wssmb.util.EventLogAspect;
import com.ssm.wssmb.util.Operation;

@Service
public class RegionServiceImpl implements RegionService {

	@Resource
	RegionMapper regionMapper;
	
	@Resource
	private EventLogAspect log;
	
	/**
	 * @Description 获取区域树状列表
	 * @param list
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	@Override
	public List<Map<String, Object>> getRegionTreeGrid(Integer regionid){
		List<Region> regions = regionMapper.selectList(regionid);
		List<Map<String, Object>> regionList=null;
		if(null != regions && regions.size() > 0){
			regionList = createTreeGrid(regions,0);
		}
		return regionList;
	}
	
	/**
	 * @Description 获取区域树集合
	 * @param list
	 * @param fid 顶级区域的父id默认为0
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	private List<Map<String, Object>> createTreeGrid(List<?> list,int fid) {
		List<Map<String, Object>> treeGridList = createTreeGridChildren(list, 0);
		return treeGridList;
	}

	/**
	 * @Description 递归区域
	 * @param list
	 * @param fid
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	private List<Map<String, Object>> createTreeGridChildren(List<?> list,int fid) {
		List<Map<String, Object>> childList = new ArrayList<Map<String, Object>>();
		for (int j = 0; j < list.size(); j++) {
			Map<String, Object> map = null;
			Region region = (Region) list.get(j);
			if (region.getParentid() == fid) {
				map = new HashMap<String, Object>();
				map = setMap(map, region);
				List<Map<String, Object>> childrenList = createTreeGridChildren(list, region.getId());
				if (null != childrenList && childrenList.size() > 0) {
					map.put("state", "open");//默认打开
					map.put("children", childrenList);//子级组织机构
				}
			}
			if (map != null)
				childList.add(map);
		}
		return childList;
	}
	
	/**
	 * @Description 设置map集合
	 * @param map
	 * @param region
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	private Map<String, Object> setMap(Map<String, Object> map, Region region) {
		map.put("id", region.getId());
		map.put("name", region.getName()); //区域名称
		map.put("text", region.getName()); //区域名称
		map.put("parentid", region.getParentid()); //上级区域id
		map.put("shortname", region.getShortname()); //简称
		map.put("leveltype", region.getLeveltype()); //层级
		map.put("citycode", region.getCitycode()); //区号
		map.put("zipcode", region.getZipcode()); //邮编
		map.put("mergername", region.getMergername()); //合称
		map.put("lng", region.getLng()); //经度
		map.put("lat", region.getLat()); //纬度
		map.put("pinyin", region.getPinyin()); //拼音
		return map;
	}
	
	/**
	 * @Description 根据条件获取区域分页列表
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@Override
	public List<Region> getRegionList(String name, int startindex, int endindex){
		Integer startin=startindex-1;
		return regionMapper.selectPageList(name, startin, endindex);
	}
	
	/**
	 * @Description 根据条件获取区域数量
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@Override
	public int getRegionsCount(String name){
		return regionMapper.selectTotalCount(name);
	}

	/**
	 * @Description 添加区域
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	@Override
    public String addRegion(Region region)throws Exception{
    	int result = regionMapper.insertSelective(region);
		if (result > 0){
			String content = "区域ID：" + region.getId();
	        log.addLog("", "添加区域", content, 0);
			return "success";
		}
		else{
			return "error";
		} 
    }

    /**
	 * @Description 修改区域
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
    @Override
    public String editRegion(Region region)throws Exception{
    	int result = regionMapper.updateByPrimaryKeySelective(region);
		if (result > 0){
			String content = "区域ID：" + region.getId();
	        log.addLog("", "修改区域", content, 2);
			return "success";
		}
		else{
			return "error";
		} 
    }

    /**
	 * @Description 删除区域
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
    @Override
	public String deleteRegion(Integer regionid)throws Exception{
    	List<Region> list = regionMapper.selectListByParentId(regionid);
		if(null != list && list.size() > 0){
			return "children"; //先删除子集组织机构
		}else{
			int result = regionMapper.deleteByPrimaryKey(regionid);
			if (result > 0){
				String content = "区域ID：" + regionid;
		        log.addLog("", "删除区域", content, 1);
				return "success";
			}
			else{
				return "error";
			}
		}
	}
	
	/**
	 * @Description 根据区域id选择区域
	 * @return
	 * @Time 2018年7月12日
	 * @Author jiym
	 */
	@Override
	public Region selectRegionById(Integer regionid)throws Exception{
    	Region region = regionMapper.selectByPrimaryKey(regionid);
    	return region;
	}
	
	/**
	 * @Description 根据组织机构代码获取区域
	 * @return
	 * @Time 2019年3月12日
	 * @Author hxl
	 */
	@Override
	public List<Region> selectRegionByOrgCode(String organizationcode)throws Exception{
		String organizationid=regionMapper.getOrganizationidByorganizationcode(organizationcode);
		List<Integer> inList = regionMapper.getIn(organizationid);
		List<Integer> inLists = regionMapper.getOtherwise();
    	return regionMapper.selectByOrgCode(organizationcode,inList,inLists);
	}
	
	/**
	 * @Description 根据组织机构ID获取区域
	 * @return
	 * @Time 2019年3月12日
	 * @Author hxl
	 */
	@Override
	public List<Region> selectRegionByOrgId(Integer organizationid)throws Exception{
    	return regionMapper.selectByOrgId(organizationid);
	}
	
	/**
	 * @Description 获取省直辖市
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@Override
	public List<Region> selectProvince()throws Exception{
    	return regionMapper.selectProvince();
	}
	
	/**
	 * @Description 根据省直辖市获取地级市
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@Override
	public List<Region> selectCity(Integer provinceid)throws Exception{
    	return regionMapper.selectCity(provinceid);
	}
	
	/**
	 * @Description 根据地级市获取区县
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	@Override
	public List<Region> selectCountry(Integer cityid)throws Exception{
    	return regionMapper.selectCountry(cityid);
	}

	@Override
	public List<Region> selectStreet(Integer countryid) throws Exception {
		return regionMapper.selectStreet(countryid);
	}

	@Override
	public Region getPar(Integer leveltype, Integer id) {
		// TODO Auto-generated method stub
		return regionMapper.getPar(leveltype, id);
	}

	@Override
	public Region selectByTwoDition(Integer Leveltype, Integer id) {
		// TODO Auto-generated method stub
		return regionMapper.selectByTwoDition(Leveltype, id);
	}


}
