package com.bjpowernode.crm.settings.mapper;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue record);

    int insertSelective(DicValue record);

    DicValue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DicValue record);

    int updateByPrimaryKey(DicValue record);

    /**
     * 获取数据字典的所有值列表数据
     * @return
     */
    List<DicValue> selectAllDicValueList();

    /**
     * 批量删除记录
     * @param id
     * @return
     */
    int deleteDicValue(String[] id);

    /**
     * 根据类型编码查询数据字典值列表
     * @param typeCode
     * @return
     */
    List<DicValue> selectDicValueListByTypeCode(String typeCode);
}