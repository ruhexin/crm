package com.bjpowernode.crm.settings.mapper;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);

    /**
     * 根据帐号和密码查询用户信息
     * @param paramMap
     * @return
     */
    User selectUserByLoginActAndLoginPwd(Map<String, Object> paramMap);

    /**
     * 根据帐号查询用户信息
     * @param loginAct
     * @return
     */
    User selectUserByLoginAct(String loginAct);

    /**
     * 获取所有用户信息列表
     * @return
     */
    List<User> selectAllUserList();
}