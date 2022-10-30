package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.mapper.DicValueMapper;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.BoundListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * ClassName:DicValueServiceImpl
 * Package:com.bjpowernode.crm.settings.service.impl
 * Date:2021/11/18 16:43
 * Description:
 * author:guoxin@126.com
 */
@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Autowired
    private RedisTemplate redisTemplate;

    @Override
    public List<DicValue> queryAllDicValueList() {
        return dicValueMapper.selectAllDicValueList();
    }

    @Override
    public int saveCreateDicValue(DicValue dicValue) {
        return dicValueMapper.insertSelective(dicValue);
    }

    @Override
    public DicValue queryDicValueById(String id) {
        return dicValueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int saveEditDicValue(DicValue dicValue) {
        return dicValueMapper.updateByPrimaryKeySelective(dicValue);
    }

    @Override
    public int deleteDicValue(String[] id) {
        return dicValueMapper.deleteDicValue(id);
    }

    @Override
    public List<DicValue> queryDicValueListByTypeCode(String typeCode) {

        //获取操作指定key的操作对象
        BoundListOperations boundListOperations = redisTemplate.boundListOps(typeCode);

        //首先去redis缓存中查询
        List<DicValue> dicValueList = boundListOperations.range(0, -1);

        //判断是否有值
        if (null == dicValueList || dicValueList.size() == 0) {

            //去数据库查询，并存放到redis缓存中
            //去数据库查询
            dicValueList = dicValueMapper.selectDicValueListByTypeCode(typeCode);

            //循环遍历dicValueList集合数据
            for (DicValue dicValue : dicValueList) {
                //并存放到redis缓存中
                boundListOperations.leftPush(dicValue);
            }

            //设置失效时间
            boundListOperations.expire(DateUtils.getRemainSecondsOneDay(new Date()), TimeUnit.SECONDS);

        }

        //有：直接返回
        return dicValueList;
    }
}
