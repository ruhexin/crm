package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    Clue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);

    /**
     * 多条件分页查询每页显示的数据
     * @param paramMap
     * @return
     */
    List<Clue> selectClueList(Map<String, Object> paramMap);

    /**
     * 多条件查询总记录数
     * @param paramMap
     * @return
     */
    Integer selectTotal(Map<String, Object> paramMap);

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
    Clue selectClueDetailById(String id);

    /**
     * 根据线索标识获取线索详情（所有者、称呼）
     * @param clueId
     * @return
     */
    Clue selectClueInfoById(String clueId);
}