package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.contants.Constant;
import com.bjpowernode.crm.commons.domain.Result;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.MD5Util;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundValueOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.settings.web.controller
 * author:郭鑫
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private RedisTemplate redisTemplate;


    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }


    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(HttpServletRequest request, HttpServletResponse response,
                                      @RequestParam(value = "loginAct",required = true) String loginAct,
                                      @RequestParam(value = "loginPwd",required = true) String loginPwd,
                                      @RequestParam(value = "isRemPwd",required = true) Boolean isRemPwd) throws ParseException {

        //根据帐号查询用户信息
        User userDetail = userService.queryUserByLoginAct(loginAct);

        //判断当前帐号是否存在
        if (null == userDetail) {
            return Result.fail("帐号不存在");
        }

        //设置redisTemplate模版对象的键的序列化方式
        redisTemplate.setKeySerializer(new StringRedisSerializer());

        //设置redisTemplate模版对象值的序列化方式
        redisTemplate.setValueSerializer(new Jackson2JsonRedisSerializer<Object>(Object.class));




        //通过redisTemplate模版对象获取操作String的操作对象
        BoundValueOperations boundValueOperations = redisTemplate.boundValueOps(loginAct);

        //从redis中获取用户输错的次数
        Integer errorCount = (Integer) boundValueOperations.get();

        //判断输错的次数是否为空
        if (null != errorCount && Constant.ERROR_MAX_COUNT == errorCount) {

            //说明当天有输错过
            //判断用户输错的次数是否小于3
            return Result.fail("当日累计输错次数已达上限，请联系管理员");
        }

        //说明当天目前还未输错过

        //成功响应的JSON格式
            //{"code":1}
        //失败响应的JSON格式
            //{"code":0,"message":"失败的消息"}
        //创建一个响应Map集合
        Map<String,Object> retMap = new HashMap<String, Object>();

        //准备查询参数
        Map<String,Object> paramMap = new HashMap<String, Object>();
        paramMap.put("loginAct",loginAct);
        paramMap.put("loginPwd", MD5Util.getMD5(loginPwd));

        //调用：用户业务接口层中的方法
        //根据帐号和密码进行登录(帐号,密码) -> 返回：Boolean、int、String|User对象
        User user = userService.queryUserByLoginActAndLoginPwd(paramMap);

        //判断用户是否存在
        if (null == user) {
            //用户名或密码有误
            /*retMap.put("code",0);
            retMap.put("message","用户名或密码有误");
            return retMap;*/
            //密码输错次数+1
            boundValueOperations.increment(1.0);
            //设置失效时间
            boundValueOperations.expire(DateUtils.getRemainSecondsOneDay(new Date()),TimeUnit.SECONDS);
            return Result.fail("用户名或密码有误");
        }

        //获取帐号的失效时间
        String expireTime = user.getExpireTime();

        //不失效：失效时间字段为空，或者，当前时间小于失效时间
        //判断帐号是否失效:如果失效时间不为空且当前时间大于失效时间
        if (!"".equals(expireTime) && new Date().compareTo(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(expireTime)) > 0) {
            return Result.fail("帐号已失效，请联系管理员");
        }

        //获取帐户的锁定状态
       String lockState = user.getLockState();

        //状态不正常：锁定状态字段值为0
        //判断帐号的状态是否正常
        if ("0".equals(lockState)) {
            return Result.fail("帐号状态异常，请联系管理员");
        }

        //获取允许访问的IP地址
        String allowIps = user.getAllowIps();

        //获取请求用户的ip地址
        String remoteAddr = request.getRemoteAddr();
//        String remoteHost = request.getRemoteHost();
//        String localAddr = request.getLocalAddr();

        //不可以访问：allowIps不包含请求用户的IP地址
        //判断用户请求的IP地址是否允许访问系统
        if (!"".equals(allowIps) && !allowIps.contains(remoteAddr)) {
            return Result.fail("你访问的IP受限，请联系管理员");
        }

        //判断用户是否要记住密码
        if (isRemPwd) {
            //将帐号和密码存放到cookie中
            Cookie c1 = new Cookie("loginAct",loginAct);
            //设置cookie c1的失效时间
            c1.setMaxAge(60*60*24*7*1000);
            response.addCookie(c1);

            Cookie c2 = new Cookie("loginPwd",loginPwd);
            c2.setMaxAge(60*60*24*7*1000);
            response.addCookie(c2);

        }







        //retMap.put("code","1");
        //用户名和密码验证成功之后还需要将用户的信息存放到session中
        request.getSession().setAttribute(Constant.SESSION_USER,user);
        return Result.success();
    }


    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletRequest request) {

        //清除指定的session或者让session失效
        request.getSession().removeAttribute(Constant.SESSION_USER);
//        request.getSession().invalidate();

        return "redirect:/";
    }
}
