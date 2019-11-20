package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.User;

public interface UserMapper {
    int deleteByPrimaryKey(int id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(int id);
    
    User selectByUserName(String username);
    
    /**
     * @Description 根据账号类型获取账号集合
     * @return
     * @Time 2018年11月27日
     * @Author hxl
     */
    List<User> selectUserList(@Param(value = "usertype")Integer usertype, @Param(value = "organizationcode")String organizationcode, 
    		@Param(value = "organizationname")String organizationname, @Param(value = "username")String username);
    
    /**
     * @Description 通过id数组查询账户集合
     * @return
     * @Time 2018年1月12日
     * @Author wys
     */
    public  List<User> selectUsersByArray(Integer[] array);
    
    /**
     * @Description 查询id数组之外的使用的账户集合 
     * @param userid
     * @return
     * @Time 2018年1月12日
     * @Author wys
     * @Update hxl 2018-11-27 增加账号类型参数
     * @Update hxl 2018-12-05 增加组织机构代码参数
     */
    public List<User> selectUsersByArrayOutside(@Param(value = "array")Integer[] array, @Param(value = "usertype")int usertype,
    		@Param(value = "organizationcode")String organizationcode);
    
    int selectCountByName(@Param(value = "username")String username, @Param(value = "id")Integer id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);
    
    int resetPassword(@Param(value = "password")String password, @Param(value = "id")int id);
    
    int changePassword(@Param(value = "password")String password,@Param(value = "username")String username);
    
    List<Integer> selectUserRoles(int id);
    
    int deleteUserRoles(int id);
    
    int insertUserRoles(@Param(value = "userid")int userid, @Param(value = "roles")List<Integer> roles);

	int changeTheme(@Param(value = "id")Integer id, @Param(value = "theme")String theme);
	
	List<User> SelectUserByOrg(@Param(value = "orgid")Integer orgid);
	
	List<User> SelectUserByName(@Param(value = "username")String username);
	
}