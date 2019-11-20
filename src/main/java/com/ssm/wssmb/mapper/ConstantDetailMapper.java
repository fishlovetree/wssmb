package com.ssm.wssmb.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.ssm.wssmb.model.ConstantDetail;

public interface ConstantDetailMapper {
    int deleteByPrimaryKey(Integer detailid);

    int insert(ConstantDetail record);

    int insertSelective(ConstantDetail record);

    ConstantDetail selectByPrimaryKey(Integer detailid);
    
    ConstantDetail selectByDetailValue(@Param("coding") Integer coding,@Param("detailvalue") String detailvalue);
    
    /**
     * @Description 通过编码和名称获取值
     * @param coding detailname
     * @return
     * @Time 2018年4月25日
     * @Author lmn
     */
    ConstantDetail selectByDetailName(@Param("coding") Integer coding,@Param("detailname") String detailname);
    
    int updateByPrimaryKeySelective(ConstantDetail record);

    int updateByPrimaryKey(ConstantDetail record);
    
    List<ConstantDetail> selectListByCoding(Integer coding);
    
    /**
     * @Description 通过编码获取常量名称数组
     * @param coding
     * @return
     * @Time 2018年1月23日
     * @Author wys
     */
    public String[] selectNameArrayByCoding(Integer coding);
    
    List<ConstantDetail> selectList();
}