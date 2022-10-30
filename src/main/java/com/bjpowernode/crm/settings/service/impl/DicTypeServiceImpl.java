package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.commons.contants.Constant;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.mapper.DicTypeMapper;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * ClassName:DicTypeServiceImpl
 * Package:com.bjpowernode.crm.settings.service.impl
 * Date:2021/11/17 17:05
 * Description:
 * author:guoxin@126.com
 */
@Service
public class DicTypeServiceImpl implements DicTypeService {

    @Autowired
    private DicTypeMapper dicTypeMapper;

    @Autowired
    private RedisTemplate redisTemplate;

    @Override
    public List<DicType> queryAllDicTypeList() {
        return dicTypeMapper.selectAllDicTypeList();
    }

    @Override
    public DicType queryDicTypeByCode(String code) {
        return dicTypeMapper.selectByPrimaryKey(code);
    }

    @Override
    public int saveCreateDicType(DicType dicType) {

        int count = dicTypeMapper.insertSelective(dicType);

        if (count == 1) {
            //清空之前redis缓存中的数据
            redisTemplate.delete(Constant.ALL_DIC_TYPE);
        }

        return count;
    }

    @Override
    public int saveEditDicType(DicType dicType) {

        int count = dicTypeMapper.updateByPrimaryKeySelective(dicType);
        if (count == 1) {
            //清空之前redis缓存中的数据
            redisTemplate.delete(Constant.ALL_DIC_TYPE);
        }

        return count;
    }

    @Override
    public int deleteDicType(String[] code) {
        //1.循环数组，调用删除方法deleteByPrimaryKey（效率低，需要创建多个连接）
        //2.批量删除，需要在SQL语句中进行批量删除（效率高）

        int count = dicTypeMapper.deleteDicType(code);
        if (count != 0) {
            //清空之前redis缓存中的数据
            redisTemplate.delete(Constant.ALL_DIC_TYPE);
        }

        return count;
    }

    @Override
    public List<DicType> queryAllDictionaryTypeList() {
        //获取操作指定key的操作对象
        BoundListOperations boundListOperations = redisTemplate.boundListOps(Constant.ALL_DIC_TYPE);

        //从redis缓存中获取数据
        List<DicType> dicTypeList = boundListOperations.range(0, -1);

        //判断是否有值
        if (null == dicTypeList || dicTypeList.size() == 0) {

            //去数据库查询
            dicTypeList = dicTypeMapper.selectAllDicTypeList();

            //循环遍历dicTypeList集合
            for (DicType dicType : dicTypeList) {

                //并存放到redis缓存中
                boundListOperations.leftPush(dicType);

            }

            //设置失效时间
            boundListOperations.expire(60*60*24*30, TimeUnit.SECONDS);
//            boundListOperations.expire(10, TimeUnit.SECONDS);
        }

        //直接返回
        return dicTypeList;
    }
}
