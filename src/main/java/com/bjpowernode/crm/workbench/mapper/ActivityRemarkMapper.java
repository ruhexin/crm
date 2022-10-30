package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark record);

    int insertSelective(ActivityRemark record);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ActivityRemark record);

    int updateByPrimaryKey(ActivityRemark record);

    /**
     * 根据市场活动标识获取市场活动备注列表数据
     * @param activityId
     * @return
     */
    List<ActivityRemark> selectActivityRemarkListByActivityId(String activityId);
}