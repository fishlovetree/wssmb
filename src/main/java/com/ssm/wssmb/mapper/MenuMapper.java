package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.Menu;

public interface MenuMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Menu record);

    int insertSelective(Menu record);


    /**
     * @Description 获取菜单集合
     * @return
     * @Time 2018年1月11日
     * @Author wys
     * @Update 2018-11-23 by hxl
     */
    public List<Menu> selectMenuList(@Param(value="menutype")Integer menutype);
    
    /**
     * @Description 通过上级菜单id获取子菜单集合
     * @param id
     * @return
     * @Time 2018年1月11日
     * @Author wys
     */
    public List<Menu> selectMenuListBySuperId(Integer id);
    
    /**
     * @Description 通过菜单id查询不是该菜单和该菜单下级菜单的集合
     * @param id
     * @return
     * @Time 2018年1月15日
     * @Author wys
     * @Update 2018-11-23 by hxl
     */
    public List<Menu> selectOtherMenuListById(@Param(value="id")Integer id, @Param(value="menutype")Integer menutype);
    
    /**
     * @Description
     * @param id
     * @return
     * @Time 2018年1月9日
     * @Author wys
     */
    public List<Menu> getMenusByArray(Integer[] menuIds);
    
    Menu selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Menu record);

    int updateByPrimaryKey(Menu record);
    
    /**
	 * @Description 根据账号获取菜单集合
	 * @param userid 账号ID
	 * @return
	 * @throws Exception
	 * @Time 2018年1月30号
	 * @Author hxl
	 */
    public List<Menu> getUserMenuList(@Param(value="userid")Integer userid, 
    		@Param(value="menutype")String menutype);
    
    /**
     * @Description 设置菜单图标
     * @param id
     * @param menuicon
     * @return
     * @Time 2018年1月10日
     * @Author wys
     */
    public int updateIcon(@Param(value="id") Integer id,@Param(value="menuicon") String menuicon);
    
    /**
     * @Description 修改菜单状态
     * @param id
     * @param status
     * @return
     * @Time 2018年1月11日
     * @Author wys
     */
    public int updateMenuStatus(@Param(value="id") Integer id,@Param(value="status") Integer status);
    
    /**
     * @Description 通过名字查询菜单
     * @param menuname
     * @return
     * @Time 2018年1月11日
     * @Author wys
     * @Update 2018-11-23 by hxl
     */
    public int selectCountByName(@Param(value="menuname")String menuname, @Param(value = "id")Integer id, 
    		@Param(value="menutype")Integer menutype);
}