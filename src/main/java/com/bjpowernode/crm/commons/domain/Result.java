package com.bjpowernode.crm.commons.domain;

import com.bjpowernode.crm.commons.contants.Constant;

import java.util.HashMap;

/**
 * ClassName:Result
 * Package:com.bjpowernode.crm.commons.domain
 * Date:2021/11/13 10:56
 * Description:响应结果对象
 * author:guoxin@126.com
 */
public class Result extends HashMap<String,Object> {

    /**
     * 响应成功
     * @return
     */
    public static Result success() {
        Result result = new Result();
        result.put("code", Constant.RETURN_CODE_SUCCESS);
        return result;
    }

    /**
     * 响应成功
     * @param object 响应参数
     * @return
     */
    public static Result success(Object object) {
        Result result = new Result();
        result.put("code", Constant.RETURN_CODE_SUCCESS);
        result.put("data",object);
        return result;
    }


    /**
     * 响应失败
     * @param message
     * @return
     */
    public static Result fail(String message) {
        Result result = new Result();
        result.put("code",Constant.RETURN_CODE_FAIL);
        result.put("message",message);
        return result;
    }
}
