package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

/**
 * ClassName:ClueActivityRelationService
 * Package:com.bjpowernode.crm.workbench.service
 * Date:2021/11/27 16:12
 * Description:
 * author:guoxin@126.com
 */
public interface ClueActivityRelationService {

    /**
     * 解除线索与市场活动的关系
     * @param clueActivityRelation
     * @return
     */
    int doUnbindClueActivityRelation(ClueActivityRelation clueActivityRelation);

    /**
     * 批量保存
     * @param clueActivityRelationList
     * @return
     */
    int saveBindClueActivityRelationList(List<ClueActivityRelation> clueActivityRelationList);
}
