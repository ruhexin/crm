package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Constant;
import com.bjpowernode.crm.commons.domain.PaginationVO;
import com.bjpowernode.crm.commons.domain.Result;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.*;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.workbench.web.controller
 * Date:2021/11/12 9:12
 * Description:
 * author:guoxin@126.com
 */
@Controller
public class ActivityController {

    @Autowired
    private ActivityService activityService;

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index() {


        return "workbench/activity/index";
    }


    @RequestMapping("/workbench/activity/detail.do")
    public String detail(HttpServletRequest request,
                         @RequestParam(value = "id",required = true) String id) {

        //根据市场活动标识获取市场活动的详情
        Activity activity = activityService.queryActivityAllDetailById(id);
        request.setAttribute("activity",activity);


        return "workbench/activity/detail";
    }

    @RequestMapping("/workbench/activity/queryActivityListForPageByCondition.do")
    public @ResponseBody Object queryActivityListForPageByCondition(@RequestParam(value = "activityName",required = false) String activityName,
                                                                    @RequestParam(value = "ownerName",required = false) String ownerName,
                                                                    @RequestParam(value = "startDate",required = false) String startDate,
                                                                    @RequestParam(value = "endDate",required = false) String endDate,
                                                                    @RequestParam(value = "pageNo",required = true) Integer pageNo,
                                                                    @RequestParam(value = "pageSize",required = true) Integer pageSize) {

        //准备分页查询参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("activityName",activityName);
        paramMap.put("ownerName",ownerName);
        paramMap.put("startDate",startDate);
        paramMap.put("endDate",endDate);
        paramMap.put("pageNo",(pageNo-1)*pageSize);
        paramMap.put("pageSize",pageSize);

        //调用市场活动的业务层方法获取分页的数据
        //多条件分页查询市场活动列表(市场活动名称,拥有者名称,开始日期,结束日期,页码,每页显示条数) -> 返回:每页展示的列表数据List,总记录数int
        //封装分页查询显示的结果对象：分页模型对象PaginationVO，拥有2个属性：每页展示的列表数据,总记录数
        PaginationVO<Activity> paginationVO = activityService.queryActivityListForPageByCondition(paramMap);



        return paginationVO;
    }


    @RequestMapping("/workbench/activity/queryAllUserList.do")
    public @ResponseBody Object queryAllUserList() {

        //获取所有的用户列表数据
        List<User> userList = userService.queryAllUserList();

        return userList;
    }


    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(HttpServletRequest request,Activity activity) {
        //从session中获取用户信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        try {
            //完善市场活动的信息
            activity.setId(UUIDUtils.getUUID());
            activity.setCreateBy(sessionUser.getId());
            activity.setCreateTime(DateUtils.formatDateTime(new Date()));

            //保存市场活动
            int count = activityService.saveCreateActivity(activity);
            if (count != 1) {
                return Result.fail("保存失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败");
        }

        return Result.success();
    }


    @RequestMapping("/workbench/activity/editActivityPage.do")
    public @ResponseBody Object editActivityPage(@RequestParam(value = "id",required = true) String id) {

        Map<String,Object> retMap = new HashMap<String, Object>();

        //根据市场活动标识获取市场活动详情
        Activity activity = activityService.queryActivityById(id);

        //获取用户信息列表
        List<User> userList = userService.queryAllUserList();

        retMap.put("activity",activity);
        retMap.put("userList",userList);

        return retMap;
    }

    @RequestMapping("/workbench/activity/saveEditActivity.do")
    public @ResponseBody Object saveEditActivity(HttpServletRequest request,Activity activity) {
        //从session中获取用户信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        try {
            //完善市场活动信息
            activity.setEditBy(sessionUser.getId());
            activity.setEditTime(DateUtils.formatDateTime(new Date()));

            //更新市场活动信息
            int count = activityService.saveEditActivity(activity);
            if (count != 1) {
                return Result.fail("更新失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败");
        }

        return Result.success();
    }


    @RequestMapping("/workbench/activity/deleteActivity.do")
    public @ResponseBody Object deleteActivity(String[] id) {

        int count = 0;

        try {
            //批量删除记录
            count = activityService.deleteActivity(id);

            if (count == 0) {
                return Result.fail("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("删除失败");
        }

        return Result.success(count);
    }


    @RequestMapping("/workbench/activity/importActivityList.do")
    public @ResponseBody Object importActivityList(HttpServletRequest request,MultipartFile activityFile,String username) {
        //从session中获取用户信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        int count = 0;
        try {

            //将excel中的数据导入到数据库中
            //创建工作簿
            HSSFWorkbook wb = new HSSFWorkbook(activityFile.getInputStream());

            //创建sheet对象
            HSSFSheet sheet = wb.getSheetAt(0);

            //获取行对象:行号是从0开始计数
            HSSFRow row = null;

            //获取单元格：列是从0开始计数
            HSSFCell cell = null;

            //创建集合保存数据
            List<Activity> activityList = new ArrayList<Activity>();
            Activity activity = null;

            //从excel表中的第2行开始循环获取数据
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {

                //获取第i行数据
                row = sheet.getRow(i);
                activity = new Activity();

                //获取当前行的第1列
                cell = row.getCell(0);
                String activityName = cell.getStringCellValue();

                cell = row.getCell(1);
                String cost = cell.getStringCellValue();

                cell = row.getCell(2);
                String startDate = cell.getStringCellValue();

                cell = row.getCell(3);
                String endDate = cell.getStringCellValue();

                activity.setId(UUIDUtils.getUUID());
                activity.setCreateBy(sessionUser.getId());
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                activity.setName(activityName);
                activity.setCost(cost);
                activity.setStartDate(startDate);
                activity.setEndDate(endDate);

                activityList.add(activity);
            }

            //批量保存市场活动对象
            count = activityService.saveImportActivityList(activityList);
            if (count == 0) {
                return Result.fail("上传失败");
            }


        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("上传失败");
        }
        return Result.success(count);
    }

    @RequestMapping("/workbench/activity/exportActivityAll.do")
    public void exportActivityAll(HttpServletRequest request, HttpServletResponse response) {

        try {
            //获取导出的数据
            List<Activity> activityList = activityService.queryAllActivityList();

            //创建工作簿
            HSSFWorkbook wb = new HSSFWorkbook();

            //创建sheet
            HSSFSheet sheet = wb.createSheet();

            //创建行
            HSSFRow row = sheet.createRow(0);

            //创建列
            HSSFCell cell = row.createCell(0);
            cell.setCellValue("市场活动名称");

            cell = row.createCell(1);
            cell.setCellValue("成本");

            cell = row.createCell(2);
            cell.setCellValue("开始时间");

            cell = row.createCell(3);
            cell.setCellValue("结束时间");

            //循环遍历集合
            for (int i = 0; i < activityList.size(); i++) {
                //创建行
                row = sheet.createRow(i+1);

                cell = row.createCell(0);
                cell.setCellValue(activityList.get(i).getName());

                cell = row.createCell(1);
                cell.setCellValue(activityList.get(i).getCost());

                cell = row.createCell(2);
                cell.setCellValue(activityList.get(i).getStartDate());

                cell = row.createCell(3);
                cell.setCellValue(activityList.get(i).getEndDate());

            }


            //设置中文文件名称
            String fileName = URLEncoder.encode("市场活动列表","UTF-8");
            //浏览器默认服务器传过去的是html，不是excel文件
            //设置响应类型:传输内容是流，并支持中文
            response.setContentType("application/octet-stream;charset=UTF-8");
            //设置响应头信息header，下载时以文件附件下载
            response.setHeader("Content-Disposition","attachment;filename="+fileName+".xls");
            //输出流对象
            OutputStream os = response.getOutputStream();
            wb.write(os);
            //强制刷新
            os.flush();
            os.close();
            wb.close();
        } catch (Exception e) {
            e.printStackTrace();
        }


    }


    @RequestMapping("/workbench/activity/queryActivityRemarkList.do")
    public @ResponseBody Object queryActivityRemarkList(@RequestParam(value = "activityId",required = true) String activityId) {

        //根据市场活动标识获取市场活动备注列表数据
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkListByActivityId(activityId);

        return activityRemarkList;
    }


    @RequestMapping("/workbench/activity/saveCreateRemark.do")
    public @ResponseBody Object saveCreateRemark(HttpServletRequest request,ActivityRemark activityRemark) {

        //从session中获取用户的信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        try {
            //完善市场活动备注内容
            activityRemark.setId(UUIDUtils.getUUID());
            activityRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
            activityRemark.setCreateBy(sessionUser.getId());

            //保存市场活动备注
            int count = activityRemarkService.saveCreateRemark(activityRemark);
            if (count != 1) {
                return Result.fail("保存失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败");
        }
        return Result.success();
    }

    @RequestMapping("/workbench/activity/saveEditRemark.do")
    public @ResponseBody Object saveEditRemark(HttpServletRequest request,ActivityRemark activityRemark) {
        //从session中获取用户的信息
        User sessionUser = (User) request.getSession().getAttribute(Constant.SESSION_USER);

        try {
            //完善备注内容
            activityRemark.setEditBy(sessionUser.getId());
            activityRemark.setEditTime(DateUtils.formatDateTime(new Date()));

            //保存更新市场活动备注内容
            int count = activityRemarkService.saveEditRemark(activityRemark);
            if (count != 1) {
                return Result.fail("保存失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败");
        }

        return Result.success();
    }

    @RequestMapping("/workbench/activity/delActivityRemark.do")
    public @ResponseBody Object delActivityRemark(@RequestParam(value = "id",required = true) String id) {

        try {
            //删除备注内容
            int count = activityRemarkService.delActivityRemark(id);
            if (count != 1) {
                return Result.fail("删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("删除失败");
        }


        return Result.success();
    }
}
