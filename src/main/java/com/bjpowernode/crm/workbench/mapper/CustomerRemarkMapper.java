package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark record);

    int insertSelective(CustomerRemark record);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CustomerRemark record);

    int updateByPrimaryKey(CustomerRemark record);

    /**
     * 批量新增客户备注数据
     * @param customerRemarkList
     * @return
     */
    int insertCustomerRemarkList(List<CustomerRemark> customerRemarkList);
}