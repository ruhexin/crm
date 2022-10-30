package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Constant;
import com.bjpowernode.crm.commons.domain.PaginationVO;
import com.bjpowernode.crm.commons.domain.Result;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueActivityRelationService;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.workbench.web.controller
 * Date:2021/11/12 9:18
 * Description:
 * author:guoxin@126.com
 */
@Controller
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request) {

        //所有者列表
        List<User> userList = userService.queryAllUserList();
        request.setAttribute("userList",userList);

        //线索来源列表
        List<DicValue> sourceList = dicValueService.queryDicValueListByTypeCode("source");
        request.setAttribute("sourceList",sourceList);

        //线索状态列表
        List<DicValue> clueStateList = dicValueService.queryDicValueListByTypeCode("clueState");
        request.setAttribute("clueStateList",clueStateList);

        //称呼列表
        List<DicValue> appellationList = dicValueService.queryDicValueListByTypeCode("appellation");
        request.setAttribute("appellationList",appellationList);


        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(HttpServletRequest request,
                             @RequestParam(value = "id",required = true) String id) {
        //根据线索标识获取线索详情
        Clue clue = clueService.queryClueDetailById(id);
        request.setAttribute("clue",clue);


        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryClueList.do")
    public @ResponseBody Object queryClueList(@RequestParam(value = "pageNo",required = true) Integer pageNo,
                                              @RequestParam(value = "pageSize",required = true) Integer pageSize,
                                              @RequestParam(value = "fullName",required = false) String fullName,
                                              @RequestParam(value = "company",required = false) String company,
                                              @RequestParam(value = "owner",required = false) String owner,
                                              @RequestParam(value = "phone",required = false) String phone,
                                              @RequestParam(value = "mphone",required = false) String mphone,
                                              @RequestParam(value = "clueStat",required = false) String clueStat,
                                              @RequestParam(value = "source",required = false) String source) {

        Map<String,Object> retMap = new HashMap<String, Object>();

        //准备查询参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("pageNo",(pageNo-1)*pageSize);
        paramMap.put("pageSize",pageSize);
        paramMap.put("fullName",fullName);
        paramMap.put("company",company);
        paramMap.put("owner",owner);
        paramMap.put("phone",phone);
        paramMap.put("mphone",mphone);
        paramMap.put("clueStat",clueStat);
        paramMap.put("source",source);

        //多条件分页查询
        PaginationVO<Clue> paginationVO = clueService.queryClueList(paramMap);

        //计算总页数
        int totalPage = paginationVO.getTotal() / pageSize;

        //再次求余
        int mod = paginationVO.getTotal() % pageSize;
        if (mod > 0) {
            totalPage = totalPage + 1;
        }

        retMap.put("totalPage",totalPage);
        retMap.put("totalRows",paginationVO.getTotal());
        retMap.put("clueList",paginationVO.getDataList());


        return retMap;
    }


    @RequestMapping("/workbench/clue/saveCreateClue.do")
    public @ResponseBody Object saveCreateClue(HttpServletRequest request,Clue clue) {

        //从session中获取用户的信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        try {
            //完善线索信息
            clue.setId(UUIDUtils.getUUID());
            clue.setCreateBy(sessionUser.getId());
            clue.setCreateTime(DateUtils.formatDateTime(new Date()));

            //保存线索对象
            int count = clueService.saveCreateClue(clue);
            if (count != 1) {
                return Result.fail("保存失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败");
        }


        return Result.success();
    }

    @RequestMapping("/workbench/clue/editCluePage.do")
    public @ResponseBody Object editCluePage(@RequestParam(value = "id",required = true) String id) {

        //根据线索标识线索详情
        Clue clue = clueService.queryClueById(id);

        return clue;
    }


    @RequestMapping("/workbench/clue/saveEditClue.do")
    public @ResponseBody Object saveEditClue(HttpServletRequest request,Clue clue) {
        //从session中获取用户的信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        try {

            //完善线索信息
            clue.setEditBy(sessionUser.getId());
            clue.setEditTime(DateUtils.formatDateTime(new Date()));

            //更新线索信息
            int count = clueService.saveEditClue(clue);
            if (count != 1) {
                return Result.fail("更新失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败");
        }

        return Result.success();
    }

    @RequestMapping("/workbench/clue/deleteClue.do")
    public @ResponseBody Object deleteClue(@RequestParam(value = "id",required = true) String[] id) {
        int count = 0;

        try {
            //批量删除记录
            count = clueService.deleteClue(id);
            if (count == 0) {
                return Result.fail("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("删除失败");
        }

        return Result.success(count);
    }

    @RequestMapping("/workbench/clue/queryClueRemarkList.do")
    public @ResponseBody Object queryClueRemarkList(@RequestParam(value = "clueId",required = true) String clueId) {

        //根据线索标识获取线索的备注列表数据
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkListByClueId(clueId);

        return clueRemarkList;
    }

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    public @ResponseBody Object saveCreateClueRemark(HttpServletRequest request,ClueRemark clueRemark) {
        //从session中获取用户的信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        try {

            //完善备注对象信息
            clueRemark.setId(UUIDUtils.getUUID());
            clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
            clueRemark.setCreateBy(sessionUser.getId());
            //保存线索备注
            int count = clueRemarkService.saveCreateClueRemark(clueRemark);
            if (count != 1) {
                return Result.fail("保存失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败");
        }

        return Result.success();
    }


    @RequestMapping("/workbench/clue/saveEditClueRemark.do")
    public @ResponseBody Object saveEditClueRemark(HttpServletRequest request,ClueRemark clueRemark) {
        //从session中获取用户的信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        try {
            //完善备注内容
            clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));
            clueRemark.setEditBy(sessionUser.getId());

            //保存更新备注内容
            int count = clueRemarkService.saveEditClueRemark(clueRemark);
            if (count != 1) {
                return Result.fail("更新失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败");
        }

        return Result.success();
    }

    @RequestMapping("/workbench/clue/deleteClueRemark.do")
    public @ResponseBody Object deleteClueRemark(@RequestParam(value = "id",required = true) String id) {

        try {
            //删除备注内容
            int count = clueRemarkService.deleteClueRemark(id);
            if (count != 1) {
                return Result.fail("删除失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("删除失败");
        }

        return Result.success();
    }

    @RequestMapping("/workbench/clue/queryClueActivityList.do")
    public @ResponseBody Object queryClueActivityList(@RequestParam(value = "clueId",required = true) String clueId) {

        //查询线索关联的市场活动列表数据
        List<Activity> activityList = activityService.queryClueActivityListByClueId(clueId);

        return activityList;
    }


    @RequestMapping("/workbench/clue/unbindClueActivityRelation.do")
    public @ResponseBody Object unbindClueActivityRelation(ClueActivityRelation clueActivityRelation) {

        try {
            //解除线索与市场活动的关系
            int count = clueActivityRelationService.doUnbindClueActivityRelation(clueActivityRelation);
            if (count != 1) {
                return Result.fail("解除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("解除失败");
        }

        return Result.success();
    }

    @RequestMapping("/workbench/clue/queryUnbindClueActivityRelationList.do")
    public @ResponseBody Object queryUnbindClueActivityRelationList(@RequestParam(value = "clueId",required = true) String clueId,
                                                                    @RequestParam(value = "searchActivityName",required = false) String searchActivityName) {

        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("clueId",clueId);
        paramMap.put("searchActivityName",searchActivityName);

        //查询未关联的市场活动列表
        List<Activity> activityList = activityService.queryUnbindClueActivityRelationList(paramMap);

        return activityList;
    }

    @RequestMapping("/workbench/clue/saveBindClueActivityRelation.do")
    public @ResponseBody Object saveBindClueActivityRelation(@RequestParam(value = "id",required = true) String[] id,
                                                             @RequestParam(value = "clueId",required = true) String clueId) {
        int count = 0;
        try {
            //准备参数
            List<ClueActivityRelation> clueActivityRelationList = new ArrayList<>();
            ClueActivityRelation clueActivityRelation = null;
            //循环遍历
            for (String i : id) {
                clueActivityRelation = new ClueActivityRelation();
                clueActivityRelation.setId(UUIDUtils.getUUID());
                clueActivityRelation.setClueId(clueId);
                clueActivityRelation.setActivityId(i);

                clueActivityRelationList.add(clueActivityRelation);
            }
            //批量保存
            count = clueActivityRelationService.saveBindClueActivityRelationList(clueActivityRelationList);
            if (count == 0) {
                return Result.fail("关联失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("关联失败");
        }

        return Result.success(count);
    }

    @RequestMapping("/workbench/clue/convertPage.do")
    public String convertPage(HttpServletRequest request,
                              @RequestParam(value = "clueId",required = true) String clueId) {

        //根据线索标识获取线索详情
        Clue clue = clueService.queryClueInfoById(clueId);
        request.setAttribute("clue",clue);

        //获取阶段数据列表
        List<DicValue> stageList = dicValueService.queryDicValueListByTypeCode("stage");
        request.setAttribute("stageList",stageList);


        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryBindActivityList.do")
    public @ResponseBody Object queryBindActivityList(String activityName,String clueId) {

        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("activityName",activityName);
        paramMap.put("clueId",clueId);

        //根据市场活动名称模糊查询线索已关联的市场活动列表
        List<Activity> activityList = activityService.queryClueActivityListByClueIdAndActivityName(paramMap);


        return activityList;
    }

    @RequestMapping("/workbench/clue/convert.do")
    public @ResponseBody Object convert(HttpServletRequest request,
                                        @RequestParam(value = "clueId",required = true) String clueId,
                                        @RequestParam(value = "isCreateTransaction",required = true) Boolean isCreateTransaction,
                                        @RequestParam(value = "money",required = false) String money,
                                        @RequestParam(value = "tradeName",required = false) String tradeName,
                                        @RequestParam(value = "expectedClosingDate",required = false) String expectedClosingDate,
                                        @RequestParam(value = "stage",required = false) String stage,
                                        @RequestParam(value = "activityId",required = false) String activityId) {

        //从session中获取用户的信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        //准备转换的参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("user",sessionUser);
        paramMap.put("clueId",clueId);
        paramMap.put("isCreateTransaction",isCreateTransaction);
        paramMap.put("money",money);
        paramMap.put("tradeName",tradeName);
        paramMap.put("expectedClosingDate",expectedClosingDate);
        paramMap.put("stage",stage);
        paramMap.put("activityId",activityId);


        try {
            //线索的转换
            clueService.doConvert(paramMap);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("转换失败");
        }

        return Result.success();
    }
}
