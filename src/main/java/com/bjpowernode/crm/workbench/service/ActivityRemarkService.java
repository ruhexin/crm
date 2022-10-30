package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * ClassName:ActivityRemarkService
 * Package:com.bjpowernode.crm.workbench.service
 * Date:2021/11/24 14:43
 * Description:
 * author:guoxin@126.com
 */
public interface ActivityRemarkService {
    /**
     * 根据市场活动标识获取市场活动备注列表数据
     * @param activityId
     * @return
     */
    List<ActivityRemark> queryActivityRemarkListByActivityId(String activityId);

    /**
     * 保存市场活动备注
     * @param activityRemark
     * @return
     */
    int saveCreateRemark(ActivityRemark activityRemark);

    /**
     * 更新备注内容
     * @param activityRemark
     * @return
     */
    int saveEditRemark(ActivityRemark activityRemark);

    /**
     * 删除市场活动备注内容
     * @param id
     * @return
     */
    int delActivityRemark(String id);
}
