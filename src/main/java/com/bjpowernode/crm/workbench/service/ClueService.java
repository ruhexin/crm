package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.commons.domain.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.Map;

/**
 * ClassName:ClueService
 * Package:com.bjpowernode.crm.workbench.service
 * Date:2021/11/26 14:18
 * Description:
 * author:guoxin@126.com
 */
public interface ClueService {

    /**
     * 多条件分页查询线索列表数据
     * @param paramMap
     * @return
     */
    PaginationVO<Clue> queryClueList(Map<String, Object> paramMap);

    /**
     * 保存线索对象
     * @param clue
     * @return
     */
    int saveCreateClue(Clue clue);

    /**
     * 根据线索标识线索详情
     * @param id
     * @return
     */
    Clue queryClueById(String id);

    /**
     * 更新线索信息
     * @param clue
     * @return
     */
    int saveEditClue(Clue clue);

    /**
     * 批量删除记录
     * @param id
     * @return
     */
    int deleteClue(String[] id);

    /**
     * 根据线索标识获取线索详情（所有者、创建者、修改者、线索来源和状态）
     * @param id
     * @return
     */
    Clue queryClueDetailById(String id);

    /**
     * 根据线索标识获取线索详情（所有者、称呼）
     * @param clueId
     * @return
     */
    Clue queryClueInfoById(String clueId);

    /**
     * 线索的转换
     * @param paramMap
     */
    void doConvert(Map<String, Object> paramMap);
}
