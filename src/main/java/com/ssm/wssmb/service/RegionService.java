package com.ssm.wssmb.service;

import java.util.List;
import java.util.Map;

import com.ssm.wssmb.model.Region;

/**
 * @Description: 区域管理业务接口
 * @Author hxl
 * @Time: 2018年1月13日
 */
public interface RegionService {
	
	/**
	 * @Description 获取区域树状列表
	 * @param list
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	List<Map<String, Object>> getRegionTreeGrid(Integer regionid);
	
	/**
	 * @Description 根据条件获取区域分页列表
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	List<Region> getRegionList(String name, int startindex, int endindex);
	
	/**
	 * @Description 根据条件获取区域数量
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	int getRegionsCount(String name);

	/**
	 * @Description 添加区域
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
    String addRegion(Region region)throws Exception;

    /**
	 * @Description 修改区域
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
    String editRegion(Region region)throws Exception;

    /**
	 * @Description 删除区域
	 * @return
	 * @Time 2018年1月13日
	 * @Author hxl
	 */
	String deleteRegion(Integer regionid)throws Exception;
	
	/**
	 * @Description 根据id获取区域
	 * @return
	 * @Time 2018年7月12日
	 * @Author jiym
	 */
	Region selectRegionById(Integer regionid)throws Exception;
	
	/**
	 * @Description 根据组织机构代码获取区域
	 * @return
	 * @Time 2019年3月12日
	 * @Author hxl
	 */
	List<Region> selectRegionByOrgCode(String organizationcode)throws Exception;
	
	/**
	 * @Description 根据组织机构ID获取区域
	 * @return
	 * @Time 2019年3月12日
	 * @Author hxl
	 */
	List<Region> selectRegionByOrgId(Integer organizationid)throws Exception;
	
	/**
	 * @Description 获取省直辖市
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	List<Region> selectProvince()throws Exception;
	
	/**
	 * @Description 根据省直辖市获取地级市
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	List<Region> selectCity(Integer provinceid)throws Exception;
	
	/**
	 * @Description 根据地级市获取区县
	 * @return
	 * @Time 2019年3月13日
	 * @Author hxl
	 */
	List<Region> selectCountry(Integer cityid)throws Exception;
	
	List<Region> selectStreet(Integer countryid)throws Exception;
	
	//取上级
	Region getPar(Integer leveltype,Integer id);
	//取单个 
	Region selectByTwoDition(Integer Leveltype,Integer id);
	
}
