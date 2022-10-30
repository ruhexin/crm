package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.mapper.ClueRemarkMapper;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:ClueRemarkServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Date:2021/11/27 14:25
 * Description:
 * author:guoxin@126.com
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkListByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkListByClueId(clueId);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertSelective(clueRemark);
    }

    @Override
    public int saveEditClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.updateByPrimaryKeySelective(clueRemark);
    }

    @Override
    public int deleteClueRemark(String id) {
        return clueRemarkMapper.deleteByPrimaryKey(id);
    }
}
