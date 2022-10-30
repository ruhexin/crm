package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueActivityRelation record);

    int insertSelective(ClueActivityRelation record);

    ClueActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueActivityRelation record);

    int updateByPrimaryKey(ClueActivityRelation record);

    /**
     * 解除线索与市场活动的关系
     * @param clueActivityRelation
     * @return
     */
    int doUnbindClueActivityRelation(ClueActivityRelation clueActivityRelation);

    /**
     * 批量保存
     * @param clueActivityRelationList
     * @return
     */
    int saveBindClueActivityRelationList(List<ClueActivityRelation> clueActivityRelationList);

    /**
     * 获取线索与市场活动关系列表数据
     * @param clueId
     * @return
     */
    List<ClueActivityRelation> selectClueActivityRelationListByClueId(String clueId);

    /**
     * 删除线索关联的市场活动信息
     * @param clueId
     * @return
     */
    int deleteClueActivityRelationList(String clueId);
}