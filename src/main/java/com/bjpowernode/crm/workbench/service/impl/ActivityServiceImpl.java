package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.domain.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * ClassName:ActivityServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Date:2021/11/20 14:33
 * Description:
 * author:guoxin@126.com
 */
@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;


    @Override
    public PaginationVO<Activity> queryActivityListForPageByCondition(Map<String, Object> paramMap) {
        PaginationVO<Activity> paginationVO = new PaginationVO<>();

        //获取每页展示的数据
        List<Activity> activityList = activityMapper.selectActivityListForPageByCondition(paramMap);

        paginationVO.setDataList(activityList);

        //总记录数
        Integer total = activityMapper.selectAllCount(paramMap);

        paginationVO.setTotal(total);


        return paginationVO;
    }


    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertSelective(activity);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectByPrimaryKey(id);
    }

    @Override
    public int saveEditActivity(Activity activity) {
        return activityMapper.updateByPrimaryKeySelective(activity);
    }

    @Override
    public int deleteActivity(String[] id) {
        return activityMapper.deleteActivity(id);
    }

    @Override
    public int saveImportActivityList(List<Activity> activityList) {
        return activityMapper.saveImportActivityList(activityList);
    }

    @Override
    public List<Activity> queryAllActivityList() {
        return activityMapper.selectAllActivityList();
    }

    @Override
    public Activity queryActivityAllDetailById(String id) {
        return activityMapper.selectActivityAllDetailById(id);
    }

    @Override
    public List<Activity> queryClueActivityListByClueId(String clueId) {
        return activityMapper.selectClueActivityListByClueId(clueId);
    }

    @Override
    public List<Activity> queryUnbindClueActivityRelationList(Map<String, Object> paramMap) {
        return activityMapper.selectUnbindClueActivityRelationList(paramMap);
    }

    @Override
    public List<Activity> queryClueActivityListByClueIdAndActivityName(Map<String, Object> paramMap) {
        return activityMapper.selectClueActivityListByClueIdAndActivityName(paramMap);
    }
}
