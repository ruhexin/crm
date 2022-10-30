package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.domain.ChartVO;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * ClassName:ChartController
 * Package:com.bjpowernode.crm.workbench.web.controller
 * Date:2021/11/30 14:20
 * Description:
 * author:guoxin@126.com
 */
@Controller
public class ChartController {

    @Autowired
    private TranService tranService;

    @RequestMapping("/workbench/chart/transaction/index.do")
    public String index() {

        return "workbench/chart/transaction/index";
    }


    @RequestMapping("/workbench/chart/transaction/queryCountOfTranGroupByStage.do")
    public @ResponseBody Object queryCountOfTranGroupByStage() {

        List<ChartVO> chartVOList = tranService.queryCountOfTranGroupByStage();

        return chartVOList;
    }
}
