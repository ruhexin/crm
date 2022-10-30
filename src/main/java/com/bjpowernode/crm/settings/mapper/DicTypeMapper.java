package com.bjpowernode.crm.settings.mapper;

import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

public interface DicTypeMapper {
    int deleteByPrimaryKey(String code);

    int insert(DicType record);

    int insertSelective(DicType record);

    DicType selectByPrimaryKey(String code);

    int updateByPrimaryKeySelective(DicType record);

    int updateByPrimaryKey(DicType record);

    /**
     * 获取所有数据字典类型列表数据
     * @return
     */
    List<DicType> selectAllDicTypeList();

    /**
     * 批量删除记录
     * @param code
     * @return
     */
    int deleteDicType(String[] code);
}