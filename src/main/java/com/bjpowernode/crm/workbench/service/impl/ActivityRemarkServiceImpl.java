package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.mapper.ActivityRemarkMapper;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:ActivityRemarkServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Date:2021/11/24 14:44
 * Description:
 * author:guoxin@126.com
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;


    @Override
    public List<ActivityRemark> queryActivityRemarkListByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarkListByActivityId(activityId);
    }

    @Override
    public int saveCreateRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertSelective(activityRemark);
    }

    @Override
    public int saveEditRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateByPrimaryKeySelective(activityRemark);
    }

    @Override
    public int delActivityRemark(String id) {
        return activityRemarkMapper.deleteByPrimaryKey(id);
    }
}
