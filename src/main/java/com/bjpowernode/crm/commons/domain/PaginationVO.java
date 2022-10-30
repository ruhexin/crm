package com.bjpowernode.crm.commons.domain;

import java.util.List;

/**
 * ClassName:PaginationVO
 * Package:com.bjpowernode.crm.commons.domain
 * Date:2021/11/20 14:31
 * Description:
 * author:guoxin@126.com
 */
public class PaginationVO<T> {

    /**
     * 总记录数
     */
    private Integer total;

    /**
     * 数据
     */
    private List<T> dataList;

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
