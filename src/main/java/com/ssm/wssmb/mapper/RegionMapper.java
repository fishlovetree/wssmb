package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.Region;

public interface RegionMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Region record);

    int insertSelective(Region record);

    Region selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Region record);

    int updateByPrimaryKey(Region record);
    
    List<Region> selectList(Integer id);
    
    List<Region> selectPageList(@Param("name")String name, @Param("startin") int startin,
    		@Param("endindex") int endindex);
    
    int selectTotalCount(@Param("name")String name);
    
    List<Region> selectListByParentId(Integer parentid);
    
    
    
    /**
     * @Description 根据regionid获取下级所有区域集合（by prior）
     * @param id
     * @return
     * @Time 2018年2月26日
     * @Author lmn
     */
    List<Region> selectAllList(Integer id);
  //根据organizationcode获取organizationid
  	String getOrganizationidByorganizationcode(@Param("organizationcode")String organizationcode);
    List<Integer> getIn(@Param(value = "organizationid")String organizationid);
	List<Integer> getOtherwise();
    List<Region> selectByOrgCode(@Param("organizationcode")String organizationcode,@Param(value = "list")List<Integer> list,@Param(value = "lists")List<Integer> lists);
    
    List<Region> selectByOrgId(Integer organizationid);
    
    List<Region> selectProvince();
    
    List<Region> selectCity(Integer provinceid);
    
    List<Region> selectCountry(Integer cityid);
    
    List<Region> selectStreet(Integer countryid);
    
 //取上级
    Region getPar(Integer leveltype,Integer id);
   //取单个 
    Region selectByTwoDition(Integer Leveltype,Integer id);
}