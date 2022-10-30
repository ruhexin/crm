package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.domain.Result;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.settings.web.controller
 * Date:2021/11/12 9:07
 * Description:
 * author:guoxin@126.com
 */
@Controller
public class DicTypeController {

    @Autowired
    private DicTypeService dicTypeService;

    @RequestMapping("/settings/dictionary/type/index.do")
    public String index() {


        return "settings/dictionary/type/index";
    }

    @RequestMapping("/settings/dictionary/type/queryAllDicTypeList.do")
    public @ResponseBody Object queryAllDicTypeList() {

        //获取所有数据字典类型列表数据
        List<DicType> dicTypeList = dicTypeService.queryAllDicTypeList();

        return dicTypeList;
    }

    @RequestMapping("/settings/dictionary/type/createDicTypePage.do")
    public String createDicTypePage() {


        return "settings/dictionary/type/save";
    }

    @RequestMapping("/settings/dictionary/type/checkCode.do")
    public @ResponseBody Object checkCode(@RequestParam(value = "code",required = true) String code) {

        //验证数据字典类型的编码是否重复(类型编码) -> 返回boolean,int,String,对象
        DicType dicType = dicTypeService.queryDicTypeByCode(code);

        //判断是否重复
        if (null != dicType) {
            return Result.fail("该类型编码已存在，请更换编码");
        }

        return Result.success();
    }


    @RequestMapping("/settings/dictionary/type/saveCreateDicType.do")
    public @ResponseBody Object saveCreateDicType(DicType dicType) {

        try {
            //新增数据字典类型
            int count = dicTypeService.saveCreateDicType(dicType);
            if (count != 1) {
                return Result.fail("保存失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败");
        }
        return Result.success();
    }

    @RequestMapping("/settings/dictionary/type/editDicTypePage.do")
    public String editDicTypePage(HttpServletRequest request,
                                  @RequestParam(value = "code",required = true) String code) {

        //根据数据字典类型编码查询字典类型
        DicType dicType = dicTypeService.queryDicTypeByCode(code);
        request.setAttribute("dicType",dicType);


        return "settings/dictionary/type/edit";
    }


    @RequestMapping("/settings/dictionary/type/saveEditDicType.do")
    public @ResponseBody Object saveEditDicType(DicType dicType) {

        try {
            //更新数据字典类型内容
            int count = dicTypeService.saveEditDicType(dicType);
            if (1 != count) {
                return Result.fail("更新失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败");
        }

        return Result.success();
    }

    //code=1&code=2&code=3&....
    @RequestMapping("/settings/dictionary/type/deleteDicType.do")
    public @ResponseBody Object deleteDicType(@RequestParam(value = "code",required = true) String[] code) {

        int count = 0;
        try {
            //批量删除记录
            count = dicTypeService.deleteDicType(code);

            if (count == 0) {
                return Result.fail("删除失败");
            }


        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("删除失败");
        }
        return Result.success(count);
    }
}
