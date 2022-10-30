package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    /**
     * 多条件分页查询市场活动列表数据
     * @param paramMap
     * @return
     */
    List<Activity> selectActivityListForPageByCondition(Map<String, Object> paramMap);

    /**
     * 获取总记录数
     * @param paramMap
     * @return
     */
    Integer selectAllCount(Map<String, Object> paramMap);

    /**
     * 批量删除记录
     * @param id
     * @return
     */
    int deleteActivity(String[] id);

    /**
     * 批量保存市场活动
     * @param activityList
     * @return
     */
    int saveImportActivityList(List<Activity> activityList);

    /**
     * 获取所有市场活动列表
     * @return
     */
    List<Activity> selectAllActivityList();

    /**
     *根据市场活动标识获取市场活动的详情
     * @param id
     * @return
     */
    Activity selectActivityAllDetailById(String id);

    /**
     * 查询线索关联的市场活动列表数据
     * @param clueId
     * @return
     */
    List<Activity> selectClueActivityListByClueId(String clueId);

    /**
     * 查询未关联的市场活动列表
     * @param paramMap
     * @return
     */
    List<Activity> selectUnbindClueActivityRelationList(Map<String, Object> paramMap);

    /**
     * 根据市场活动名称模糊查询线索已关联的市场活动列表
     * @param paramMap
     * @return
     */
    List<Activity> selectClueActivityListByClueIdAndActivityName(Map<String, Object> paramMap);
}