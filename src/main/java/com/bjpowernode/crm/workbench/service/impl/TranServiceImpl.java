package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.domain.ChartVO;
import com.bjpowernode.crm.workbench.mapper.TranMapper;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:TranServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Date:2021/11/30 14:57
 * Description:
 * author:guoxin@126.com
 */
@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;

    @Override
    public List<ChartVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }
}
