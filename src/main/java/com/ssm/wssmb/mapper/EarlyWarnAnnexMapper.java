package com.ssm.wssmb.mapper;

import com.ssm.wssmb.model.EarlyWarnAnnex;

/**
 * @Description: 附件实体类
 * @Author wys
 * @Time: 2018年2月2日
 */
public interface EarlyWarnAnnexMapper {
    int deleteByPrimaryKey(Integer annexid);

    int insert(EarlyWarnAnnex record);

    int insertSelective(EarlyWarnAnnex record);

    EarlyWarnAnnex selectByPrimaryKey(Integer annexid);
    
    /**
     * @Description 通过预警id获取附件
     * @param id
     * @return
     * @Time 
     * @Author 
     */
    EarlyWarnAnnex selectByEarlyId(Integer id);

    int updateByPrimaryKeySelective(EarlyWarnAnnex record);

    int updateByPrimaryKeyWithBLOBs(EarlyWarnAnnex record);

    int updateByPrimaryKey(EarlyWarnAnnex record);
}