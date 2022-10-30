package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.commons.contants.Constant;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.UserMapper;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.settings.service.impl
 * Date:2021/11/13 10:29
 * Description:
 * author:guoxin@126.com
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RedisTemplate redisTemplate;

    @Override
    public User queryUserByLoginActAndLoginPwd(Map<String, Object> paramMap) {
        return userMapper.selectUserByLoginActAndLoginPwd(paramMap);
    }

    @Override
    public User queryUserByLoginAct(String loginAct) {
        return userMapper.selectUserByLoginAct(loginAct);
    }

    @Override
    public List<User> queryAllUserList() {
        //return userMapper.selectAllUserList();

        //获取操作指定key的操作对象
        BoundListOperations boundListOperations = redisTemplate.boundListOps(Constant.ALL_USER);

        //从redis缓存中获取数据
        List<User> userList = boundListOperations.range(0, -1);

        //判断是否有值
        if (null == userList || userList.size() == 0) {

            //去数据库查询
            userList = userMapper.selectAllUserList();

            //并存放到redis缓存中
            for (User user : userList) {
                //将用户对象存放到redis缓存中
                boundListOperations.leftPush(user);
            }

            //设置失效时间
            boundListOperations.expire(DateUtils.getRemainSecondsOneDay(new Date()), TimeUnit.SECONDS);
        }




        //直接返回
        return userList;
    }
}
