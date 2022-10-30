package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * ClassName:ClueRemarkService
 * Package:com.bjpowernode.crm.workbench.service
 * Date:2021/11/27 14:24
 * Description:
 * author:guoxin@126.com
 */
public interface ClueRemarkService {

    /**
     * 根据线索标识获取备注列表数据
     * @param clueId
     * @return
     */
    List<ClueRemark> queryClueRemarkListByClueId(String clueId);

    /**
     * 保存线索备注
     * @param clueRemark
     * @return
     */
    int saveCreateClueRemark(ClueRemark clueRemark);

    /**
     * 更新备注内容
     * @param clueRemark
     * @return
     */
    int saveEditClueRemark(ClueRemark clueRemark);

    /**
     * 删除备注内容
     * @param id
     * @return
     */
    int deleteClueRemark(String id);
}
