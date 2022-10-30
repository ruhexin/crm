package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ContactsActivityRelation record);

    int insertSelective(ContactsActivityRelation record);

    ContactsActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ContactsActivityRelation record);

    int updateByPrimaryKey(ContactsActivityRelation record);

    /**
     * 批量新增联系人与市场活动关系数据
     * @param contactsActivityRelationList
     */
    void insertContactsActivityRelationList(List<ContactsActivityRelation> contactsActivityRelationList);
}