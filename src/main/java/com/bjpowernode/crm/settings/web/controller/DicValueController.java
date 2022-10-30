package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.domain.Result;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.bjpowernode.crm.settings.service.DicValueService;
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
 * Date:2021/11/12 9:09
 * Description:
 * author:guoxin@126.com
 */
@Controller
public class DicValueController {

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private DicTypeService dicTypeService;

    @RequestMapping("/settings/dictionary/value/index.do")
    public String index() {

        return "settings/dictionary/value/index";
    }

    @RequestMapping("/settings/dictionary/value/queryAllDicValueList.do")
    public @ResponseBody Object queryAllDicValueList() {

        //获取数据字典的所有值列表数据
        List<DicValue> dicValueList = dicValueService.queryAllDicValueList();


        return dicValueList;
    }


    @RequestMapping("/settings/dictionary/value/createDicValuePage.do")
    public String createDicValuePage() {


        return "settings/dictionary/value/save";
    }


    @RequestMapping("/settings/dictionary/value/queryAllDicTypeList.do")
    public @ResponseBody Object queryAllDicTypeList() {

        //获取数据字典类型列表数据
        List<DicType> dicTypeList = dicTypeService.queryAllDictionaryTypeList();

        return dicTypeList;
    }


    @RequestMapping("/settings/dictionary/value/saveCreateDicValue.do")
    public @ResponseBody Object saveCreateDicValue(DicValue dicValue) {

        try {
            //完善对象参数
            dicValue.setId(UUIDUtils.getUUID());

            //保存数据字典值
            int count = dicValueService.saveCreateDicValue(dicValue);
            if (1 != count) {
                return Result.fail("保存失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("保存失败");
        }


        return Result.success();
    }


    @RequestMapping("/settings/dictionary/value/editDicValuePage.do")
    public String editDicValuePage(HttpServletRequest request,
                                   @RequestParam(value = "id",required = true) String id) {

        //根据标识获取数据字典值对象
        DicValue dicValue = dicValueService.queryDicValueById(id);
        request.setAttribute("dicValue",dicValue);


        return "settings/dictionary/value/edit";
    }

    @RequestMapping("/settings/dictionary/value/saveEditDicValue.do")
    public @ResponseBody Object saveEditDicValue(DicValue dicValue) {

        try {
            //更新数据字典值
            int count = dicValueService.saveEditDicValue(dicValue);
            if (count != 1) {
                return Result.fail("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.fail("更新失败");
        }

        return Result.success();
    }


    @RequestMapping("/settings/dictionary/value/deleteDicValue.do")
    public @ResponseBody Object deleteDicValue(String[] id) {

        int count = 0;
        try {
            //批量删除记录
            count = dicValueService.deleteDicValue(id);
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
