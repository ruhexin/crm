package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueRemark record);

    int insertSelective(ClueRemark record);

    ClueRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueRemark record);

    int updateByPrimaryKey(ClueRemark record);

    /**
     * 根据线索标识获取备注列表数据
     * @param clueId
     * @return
     */
    List<ClueRemark> selectClueRemarkListByClueId(String clueId);

    /**
     * 根据线索标识删除线索备注列表数据
     * @param clueId
     * @return
     */
    int deleteClueRemarkListByClueId(String clueId);

    /**
     * 获取线索的备注信息列表
     * @param clueId
     * @return
     */
    List<ClueRemark> selectClueRemarkInfoListByClueId(String clueId);
}