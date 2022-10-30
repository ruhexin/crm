package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.commons.domain.ChartVO;

import java.util.List;

/**
 * ClassName:TranService
 * Package:com.bjpowernode.crm.workbench.service
 * Date:2021/11/30 14:57
 * Description:
 * author:guoxin@126.com
 */
public interface TranService {

    /**
     * 获取交易各个阶段的交易数量
     * @return
     */
    List<ChartVO> queryCountOfTranGroupByStage();


}
