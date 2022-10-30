<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<!--  PAGINATION plugin -->
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript">

$(function(){

	//当容器加载完成，对容器调用工具函数
	$(".mydate").datetimepicker({
		language:'zh-CN',//语言
		format:'yyyy-mm-dd',//日期格式
		minView:'month',//日期选择器上最小能选择的日期的视图
		initialDate:new Date(),// 日历的初始化显示日期，此处默认初始化当前系统时间
		autoclose:true,//选择日期之后，是否自动关闭日历
		todayBtn:true,//是否显示当前日期的按钮
		clearBtn:true,//是否显示清空按钮
	});


	//给创建按钮添加单击事件
	$("#createActivityBtn").on("click",function () {

		//发起ajax异步请求，获取所有者列表数据
		$.ajax({
			url:"workbench/activity/queryAllUserList.do",
			type:"get",
			success:function (data) {
				//创建html拼接字符串
				var htmlStr = "<option></option>";

				//循环遍历集合，拼接html字符串
				$.each(data,function (index,obj) {
					htmlStr+="<option value=\""+obj.id+"\">"+obj.name+"</option>";
				});

				$("#create-marketActivityOwner").html(htmlStr);


				//打开创建市场活动模态窗口
				$("#createActivityModal").modal("show");
			}
		});






	});


	//获取市场活动列表数据
	queryActivityListForPageByCondition(1,3);

	//给查询按钮添加单击事件
	$("#queryActivityBtn").on("click",function () {
		queryActivityListForPageByCondition(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
	});


	//给新增市场活动按钮添加单击事件
	$("#saveCreateActivityBtn").on("click",function () {
		//获取所有者
		var marketActivityOwner = $("#create-marketActivityOwner").val();

		//判断是否为空
		if ("" == marketActivityOwner) {
			alert("请选择所有者");
			return;
		}

		//获取市场活动名称
		var marketActivityName = $.trim($("#create-marketActivityName").val());
		//判断是否为空
		if ("" == marketActivityName) {
			alert("请输入市场活动名称");
			return;
		}

		//获取成本
		var cost = $("#create-cost").val();

		//验证成本：只能为大于0的数字
		if (!/^(?!(0[0-9]{0,}$))[0-9]{1,}[.]{0,}[0-9]{0,}$/.test(cost)) {
			alert("成本只可输入大于0的数字");
			return;
		}

		//获取新增市场活动的页面元素
		var startDate = $("#create-startDate").val();
		var endDate = $("#create-endDate").val();
		var description = $("#create-description").val();

		//发起ajax请求
		$.ajax({
			url:"workbench/activity/saveCreateActivity.do",
			type:"post",
			data:{
				owner:marketActivityOwner,
				name:marketActivityName,
				startDate:startDate,
				endDate:endDate,
				cost:cost,
				description:description
			},
			success:function (data) {
				if (data.code == 1) {
					//关闭模态窗口
					$("#createActivityModal").modal("hide");
					//刷新列表数据
					queryActivityListForPageByCondition($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
				} else {
					alert(data.message);
				}
			}
		});
	});

	//给编辑市场活动按钮添加单击事件
	$("#editActivityBtn").on("click",function () {
		//获取用户要编辑的记录对象
		var checkeds = $("#tBody input[type='checkbox']:checked");

		//获取要编辑记录对象的数量
		//判断编辑的数量
		if (checkeds.size() != 1) {
			alert("一次只能编辑一条记录");
			return;
		}

		//获取用户选中记录的value属性值
		var id = checkeds.val();

		//发送ajax请求：反显要编辑的记录信息
		$.ajax({
			url:"workbench/activity/editActivityPage.do",
			type:"get",
			data:{
				id:id
			},
			success:function (data) {
				var htmlStr = "";

				//展示用户信息列表
				$.each(data.userList,function (index,obj) {
					htmlStr+="<option value=\""+obj.id+"\">"+obj.name+"</option>";
				});

				$("#edit-marketActivityOwner").html(htmlStr);


				$("#edit-id").val(data.activity.id);
				$("#edit-marketActivityOwner").val(data.activity.owner);
				$("#edit-marketActivityName").val(data.activity.name);
				$("#edit-startDate").val(data.activity.startDate);
				$("#edit-endDate").val(data.activity.endDate);
				$("#edit-cost").val(data.activity.cost);
				$("#edit-description").val(data.activity.description);

				//打开修改市场活动的模态窗口
				$("#editActivityModal").modal("show");
			}
		});

	});

	//给更新市场活动按钮添加单击事件
	$("#saveEditActivityBtn").on("click",function () {
		//获取市场活动名称
		var marketActivityName = $.trim($("#edit-marketActivityName").val());

		//判断市场活动名称是否为空
		if ("" == marketActivityName) {
			alert("请输入市场活动名称");
			return;
		}

		var cost = $.trim($("#edit-cost").val());

		//验证成本：只能为大于0的数字
		if (!/^(?!(0[0-9]{0,}$))[0-9]{1,}[.]{0,}[0-9]{0,}$/.test(cost)) {
			alert("成本只可输入大于0的数字");
			return;
		}

		//获取要更新的市场活动页面元素
		var id = $("#edit-id").val();
		var marketActivityOwner = $("#edit-marketActivityOwner").val();
		var startDate = $("#edit-startDate").val();
		var endDate = $("#edit-endDate").val();
		var description = $.trim($("#edit-description").val());

		//发起ajax更新请求
		$.ajax({
			url:"workbench/activity/saveEditActivity.do",
			type:"post",
			data:{
				id:id,
				owner:marketActivityOwner,
				name:marketActivityName,
				startDate:startDate,
				endDate:endDate,
				cost:cost,
				description:description
			},
			success:function (data) {
				if (data.code == 1) {
					//关闭模态窗口
					$("#editActivityModal").modal("hide");

					//刷新列表数据
					queryActivityListForPageByCondition($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
				} else {
					alert(data.message);
				}
			}
		});
	});

	//给删除按钮添加单击事件
	$("#deleteActivityBtn").on("click",function () {
		//获取到用户要删除的记录对象
		var checkeds = $("#tBody input[type='checkbox']:checked");

		//判断删除记录的数量必须大于0
		if (checkeds.size() == 0) {
			alert("请选择您要删除的记录");
			return;
		}

		//创建ids字符串
		var ids = "";

		//循环遍历：获取到每一个要删除的对象
		$.each(checkeds,function (index,obj) {
			//拼接标识字符串
			ids+="id="+$(obj).val()+"&";
		});

		// alert(ids);
		// alert(ids.substring(0,ids.length-1));
		ids=ids.substring(0,ids.length-1);

		//发起删除的ajax请求
		$.ajax({
			url:"workbench/activity/deleteActivity.do",
			type:"get",
			data:ids,
			success:function (data) {
				if (data.code == 1) {
					alert("您成功删除"+data.data+"条记录");
					//刷新列表数据
					queryActivityListForPageByCondition($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
				} else {
					alert(data.message);
				}
			}
		});
	});

	//给导入按钮添加单击事件
	$("#importActivityListBtn").on("click",function () {
		$("#importActivityModal").modal("show");
	});

	//给导入按钮添加单击事件
	$("#importActivityBtn").on("click",function () {
		//获取文件的名称
		var activityFileName = $("#activityFile").val().toString();//C:\fakepath\新建 XLS 工作表.xls
		// alert(activityFileName);

		//获取最后一个点的位置
		// activityFileName.lastIndexOf(".");

		// alert(activityFileName.substring(activityFileName.lastIndexOf(".")));
		// alert(activityFileName.substring(activityFileName.lastIndexOf(".")+1));

		//获取文件的后缀名称
		var suffix = activityFileName.substring(activityFileName.lastIndexOf(".")+1).toLowerCase();

		//判断文件的后缀是否为xls
		if ("xls" != suffix) {
			alert("操作仅针对Excel，仅支持后缀名为XLS的文件");
			return;
		}

		//获取上传文件的大小
		var file = $("#activityFile")[0].files[0];

		//判断上传文件的大小
		if ((1024 * 1024 * 5) < file.size) {
			alert("您的文件大小超过了5MB");
			return;
		}



		//js创建form表单对象
		var form = new FormData();
		form.append("activityFile",file);
		form.append("username","lisi");

		$.ajax({
			url:"workbench/activity/importActivityList.do",
			type:"post",
			data:form,
			processData:false,
			contentType:false,
			success:function (data) {
				if (data.code == 1) {
					alert("您成功导入" + data.data + "条记录");
					$("#importActivityModal").modal("hide");
					//刷新列表数据
					queryActivityListForPageByCondition($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
				} else {
					alert(data.message);
				}
			}
		});



	});

	//给批量导出添加单击事件
	$("#exportActivityAllBtn").on("click",function () {
		window.location.href = "workbench/activity/exportActivityAll.do";
	});
});

	//获取市场活动列表数据
	function queryActivityListForPageByCondition(pageNo,pageSize) {
		//获取查询参数
		var activityName = $.trim($("#query-name").val());
		var ownerName = $.trim($("#query-owner").val());
		var startDate = $("#query-startDate").val();
		var endDate = $("#query-endDate").val();

		//发送ajax请求，获取市场活动列表数据
		$.ajax({
			url:"workbench/activity/queryActivityListForPageByCondition.do",
			type:"get",
			data:{
				activityName:activityName,
				ownerName:ownerName,
				startDate:startDate,
				endDate:endDate,
				pageNo:pageNo,
				pageSize:pageSize
			},
			success:function (data) {
				var htmlStr = "";

				//循环遍历列表数据
				$.each(data.dataList,function (index,obj) {
					htmlStr+="<tr class=\"active\">";
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detail.do?id="+obj.id+"';\">"+obj.name+"</a></td>";
					htmlStr+="<td>"+obj.owner+"</td>";
					htmlStr+="<td>"+obj.startDate+"</td>";
					htmlStr+="<td>"+obj.endDate+"</td>";
					htmlStr+="</tr>";
				});

				$("#tBody").html(htmlStr);

				//计算总页数
				var totalPage = data.total / pageSize;
				//再次求余
				var mod = data.total % pageSize;
				if (mod > 0) {
					totalPage = parseInt(totalPage) + 1;
				}

				$("#demo_pag1").bs_pagination({
					currentPage:pageNo,//当前页

					rowsPerPage:pageSize,//每页显示条数
					totalRows:data.total,//总条数
					totalPages: totalPage,//总页数

					visiblePageLinks:3,//显示的翻页卡片数

					showGoToPage:true,//是否显示"跳转到第几页"
					showRowsPerPage:true,//是否显示"每页显示条数"
					showRowsInfo:true,//是否显示"记录的信息"

					//每次切换页号都会自动触发此函数，函数能够返回切换之后的页号和每页显示条数
					onChangePage: function(e,pageObj) { // returns page_num and rows_per_page after a link has clicked
						// alert(pageObj.currentPage);
						// alert(pageObj.rowsPerPage);
						queryActivityListForPageByCondition(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});

			}
		});


	}

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startDate" readonly="true">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endDate" readonly="true">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateActivityBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					    <input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startDate" value="2020-10-10" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endDate" value="2020-10-20" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveEditActivityBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls格式]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control mydate" type="text" id="query-startDate" readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control mydate" type="text" id="query-endDate" readonly>
				    </div>
				  </div>
				  
				  <button id="queryActivityBtn" type="button" class="btn btn-default">查询</button>
				  <button id="resetActivityBtn" type="reset" class="btn btn-default">重置</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createActivityBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteActivityBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button id="importActivityListBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="chked_all"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">

					</tbody>
				</table>
                <!--创建容器-->
                <div id="demo_pag1"></div>
			</div>

		</div>
		
	</div>
</body>
</html>