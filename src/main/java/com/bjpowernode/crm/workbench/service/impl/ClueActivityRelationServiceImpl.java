package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.mapper.ClueActivityRelationMapper;
import com.bjpowernode.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName:ClueActivityRelationServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Date:2021/11/27 16:13
 * Description:
 * author:guoxin@126.com
 */
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int doUnbindClueActivityRelation(ClueActivityRelation clueActivityRelation) {
        return clueActivityRelationMapper.doUnbindClueActivityRelation(clueActivityRelation);
    }

    @Override
    public int saveBindClueActivityRelationList(List<ClueActivityRelation> clueActivityRelationList) {
        return clueActivityRelationMapper.saveBindClueActivityRelationList(clueActivityRelationList);
    }
}
