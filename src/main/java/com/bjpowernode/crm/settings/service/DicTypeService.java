package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

/**
 * ClassName:DicTypeService <br/>
 * Package:com.bjpowernode.crm.settings.service
 * Date:2021/11/17 17:04
 * Description:
 * author:guoxin@126.com
 */
public interface DicTypeService {

    /**
     * 获取所有数据字典类型列表数据
     * @return List<DicTYpe>
     */
    List<DicType> queryAllDicTypeList();

    /**
     * 根据字典类型编码查询字典类型详情
     * @param code
     * @return
     */
    DicType queryDicTypeByCode(String code);

    /**
     * 新增数据字典类型
     * @param dicType
     * @return
     */
    int saveCreateDicType(DicType dicType);

    /**
     * 更新数据字典类型
     * @param dicType
     * @return
     */
    int saveEditDicType(DicType dicType);

    /**
     * 批量删除记录
     * @param code
     * @return
     */
    int deleteDicType(String[] code);

    /**
     * 获取数据字典类型列表数据（Redis）
     * @return
     */
    List<DicType> queryAllDictionaryTypeList();

}
