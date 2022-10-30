package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.domain.PaginationVO;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * ClassName:ClueServiceImpl
 * Package:com.bjpowernode.crm.workbench.service.impl
 * Date:2021/11/26 14:19
 * Description:
 * author:guoxin@126.com
 */
@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    private TranMapper tranMapper;

    @Override
    public PaginationVO<Clue> queryClueList(Map<String, Object> paramMap) {
        PaginationVO<Clue> paginationVO = new PaginationVO<>();

        //多条件分页查询每页显示的数据
        List<Clue> clueList = clueMapper.selectClueList(paramMap);
        paginationVO.setDataList(clueList);

        //多条件查询总记录数
        Integer total = clueMapper.selectTotal(paramMap);
        paginationVO.setTotal(total);

        return paginationVO;
    }

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertSelective(clue);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int saveEditClue(Clue clue) {
        return clueMapper.updateByPrimaryKeySelective(clue);
    }

    @Override
    public int deleteClue(String[] id) {
        return clueMapper.deleteClue(id);
    }

    @Override
    public Clue queryClueDetailById(String id) {
        return clueMapper.selectClueDetailById(id);
    }

    @Override
    public Clue queryClueInfoById(String clueId) {
        return clueMapper.selectClueInfoById(clueId);
    }

    @Override
    public void doConvert(Map<String, Object> paramMap) {

        //获取map集合中的参数
        User user = (User) paramMap.get("user");

        String clueId = (String) paramMap.get("clueId");
        Boolean isCreateTransaction = (Boolean) paramMap.get("isCreateTransaction");
        String money = (String) paramMap.get("money");
        String tradeName = (String) paramMap.get("tradeName");
        String expectedClosingDate = (String) paramMap.get("expectedClosingDate");
        String stage = (String) paramMap.get("stage");
        String activityId = (String) paramMap.get("activityId");



        //获取线索的详情
        Clue clue = clueMapper.selectByPrimaryKey(clueId);

        //1.将线索的详情信息转存到客户表和联系人表
        //新增客户信息
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setAddress(clue.getAddress());
        customer.setContactSummary(clue.getContactSummary());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setDescription(clue.getDescription());
        customer.setName(clue.getCompany());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setOwner(clue.getOwner());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customerMapper.insertSelective(customer);

        //新增联系人信息
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setCustomerId(customer.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullName(clue.getFullName());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contactsMapper.insertSelective(contacts);


        //获取线索的备注信息列表
//        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkListByClueId(clueId);
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkInfoListByClueId(clueId);

        //2.将线索的备注信息转换到客户备注表和联系人备注表
        List<CustomerRemark> customerRemarkList = new ArrayList<CustomerRemark>();
        CustomerRemark customerRemark = null;
        List<ContactsRemark> contactsRemarkList = new ArrayList<ContactsRemark>();
        ContactsRemark contactsRemark = null;

        //循环遍历
        for (ClueRemark clueRemark : clueRemarkList) {

            //准备客户备注列表数据
            customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtils.getUUID());
            customerRemark.setCreateBy(clueRemark.getCreateBy());
            customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemarkList.add(customerRemark);

            //准备联系人备注列表数据
            contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtils.getUUID());
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setCreateBy(clueRemark.getCreateBy());
            contactsRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemarkList.add(contactsRemark);

        }

        //新增客户备注表数据
        customerRemarkMapper.insertCustomerRemarkList(customerRemarkList);

        //新增联系人备注表数据
        contactsRemarkMapper.insertContactsRemarkList(contactsRemarkList);


        //获取到线索与市场活动关系列表数据
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationListByClueId(clueId);

        //3.转存线索与市场活动关系的数据，转换到联系人与市场活动关系表中
        List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
        ContactsActivityRelation contactsActivityRelation = null;

        //循环遍历
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {

            //准备联系人与市场活动关系数据
            contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtils.getUUID());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelationList.add(contactsActivityRelation);
        }

        //批量新增联系人与市场活动关系数据
        contactsActivityRelationMapper.insertContactsActivityRelationList(contactsActivityRelationList);


        //4.判断是否产生交易
        if (isCreateTransaction) {
            //产生：新增交易记录
            Tran tran = new Tran();
            tran.setId(UUIDUtils.getUUID());
            tran.setActivityId(activityId);
            tran.setContactsId(contacts.getId());
            tran.setContactSummary(clue.getContactSummary());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formatDateTime(new Date()));
            tran.setCustomerId(customer.getId());
            tran.setDescription(clue.getDescription());
            tran.setExpectedDate(expectedClosingDate);
            tran.setMoney(money);
            tran.setName(tradeName);
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setOwner(clue.getOwner());
            tran.setSource(clue.getSource());
            tran.setStage(stage);
            tranMapper.insertSelective(tran);
        }


        //删除线索详情
        clueMapper.deleteByPrimaryKey(clueId);
        //删除线索备注信息
        clueRemarkMapper.deleteClueRemarkListByClueId(clueId);
        //删除线索关联的市场活动信息
        clueActivityRelationMapper.deleteClueActivityRelationList(clueId);




    }
}
