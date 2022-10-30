package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * ClassName:
 * Package:com.bjpowernode.crm.settings.service
 * Date:2021/11/13 10:28
 * Description:
 * author:guoxin@126.com
 */
public interface UserService {

    /**
     * 根据用户名和密码查询用户信息
     * @param paramMap
     * @return
     */
    User queryUserByLoginActAndLoginPwd(Map<String, Object> paramMap);

    /**
     * 根据帐号查询用户信息
     * @param loginAct
     * @return
     */
    User queryUserByLoginAct(String loginAct);

    /**
     * 获取所有用户信息列表
     * @return
     */
    List<User> queryAllUserList();
}
