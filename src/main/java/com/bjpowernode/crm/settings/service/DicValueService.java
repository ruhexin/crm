package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

/**
 * ClassName:DicValueService
 * Package:com.bjpowernode.crm.settings.service
 * Date:2021/11/18 16:42
 * Description:
 * author:guoxin@126.com
 */
public interface DicValueService {

    /**
     * 获取数据字典的所有值列表数据
     * @return
     */
    List<DicValue> queryAllDicValueList();

    /**
     * 保存数据字典值
     * @param dicValue
     * @return
     */
    int saveCreateDicValue(DicValue dicValue);

    /**
     * 根据标识获取数据字典值对象
     * @param id
     * @return
     */
    DicValue queryDicValueById(String id);

    /**
     * 更新数据字典值
     * @param dicValue
     * @return
     */
    int saveEditDicValue(DicValue dicValue);

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
    List<DicValue> queryDicValueListByTypeCode(String typeCode);
}
