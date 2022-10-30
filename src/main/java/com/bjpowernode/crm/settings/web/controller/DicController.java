package com.bjpowernode.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.settings.web.controller
 * Date:2021/11/12 8:59
 * Description:
 * author:guoxin@126.com
 */
@Controller
public class DicController {

    @RequestMapping("/settings/dictionary/index.do")
    public String index() {

        return "settings/dictionary/index";
    }

}
