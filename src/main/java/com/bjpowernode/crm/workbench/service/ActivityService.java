package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.commons.domain.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * ClassName:ActivityService
 * Package:com.bjpowernode.crm.workbench.service
 * Date:2021/11/20 14:33
 * Description:
 * author:guoxin@126.com
 */
public interface ActivityService {

    /**
     * 多条件分页查询市场活动列表数据
     * @param paramMap
     * @return
     */
    PaginationVO<Activity> queryActivityListForPageByCondition(Map<String, Object> paramMap);

    /**
     * 新增市场活动
     * @param activity
     * @return
     */
    int saveCreateActivity(Activity activity);

    /**
     * 根据市场活动标识获取市场活动详情
     * @param id
     * @return
     */
    Activity queryActivityById(String id);

    /**
     * 更新市场活动信息
     * @param activity
     * @return
     */
    int saveEditActivity(Activity activity);

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
    List<Activity> queryAllActivityList();

    /**
     *根据市场活动标识获取市场活动的详情
     * @param id
     * @return
     */
    Activity queryActivityAllDetailById(String id);

    /**
     * 查询线索关联的市场活动列表数据
     * @param clueId
     * @return
     */
    List<Activity> queryClueActivityListByClueId(String clueId);

    /**
     * 查询未关联的市场活动列表
     * @param paramMap
     * @return
     */
    List<Activity> queryUnbindClueActivityRelationList(Map<String, Object> paramMap);

    /**
     * 根据市场活动名称模糊查询线索已关联的市场活动列表
     * @param paramMap
     * @return
     */
    List<Activity> queryClueActivityListByClueIdAndActivityName(Map<String, Object> paramMap);
}
