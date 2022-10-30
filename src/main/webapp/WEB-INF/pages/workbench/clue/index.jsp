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

		//加载线索列表数据
		queryClueList(1,1);

		//给查询按钮添加单击事件
		$("#conditionClueListBtn").on("click",function () {
			queryClueList(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
		});


		//保存线索信息
		$("#saveCreateClueBtn").on("click",function () {
			//获取所有者
			var owner = $("#create-clueOwner").val();

			if ("" == owner) {
				alert("所有者不能为空");
				return;
			}

			//获取公司名称
			var company = $.trim($("#create-company").val());
			if ("" == company) {
				alert("公司名称不能为空");
				return;
			}

			//获取线索名称
			var fullName = $.trim($("#create-fullName").val());
			if ("" == fullName) {
				alert("线索名称不能为空");
				return;
			}

			//获取页面的元素
			var appellation = $.trim($("#create-appellation").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var website = $.trim($("#create-website").val());
			var phone = $.trim($("#create-phone").val());
			var mphone = $.trim($("#create-mphone").val());
			var source = $.trim($("#create-source").val());
			var state = $.trim($("#create-state").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $.trim($("#create-nextContactTime").val());
			var address = $.trim($("#create-address").val());
			var description = $.trim($("#create-description").val());

			//保存的请求
			$.ajax({
				url:"workbench/clue/saveCreateClue.do",
				type:"post",
				data:{
					owner:owner,
					company:company,
					fullName:fullName,
					appellation:appellation,
					job:job,
					email:email,
					website:website,
					phone:phone,
					mphone:mphone,
					source:source,
					state:state,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					description:description
				},
				success:function (data) {
					if (data.code == 1) {
						//关闭模态窗口
						$("#createClueModal").modal("hide");
						//刷新列表数据
						queryClueList($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert(data.message);
					}
				}
			});



		});

		//给编辑按钮添加单击事件
		$("#editClueBtn").on("click",function () {
			//获取用户选中的记录对象
			var checkeds = $("#clueList input[type='checkbox']:checked");

			//判断选中的记录数
			if (checkeds.size() != 1) {
				alert("一次只能编辑一条记录");
				return;
			}

			$.ajax({
				url:"workbench/clue/editCluePage.do",
				type:"get",
				data:{
					id:checkeds.val()
				},
				success:function (data) {
					$("#edit-id").val(data.id);
					$("#edit-fullName").val(data.fullName);
					$("#edit-company").val(data.company);
					$("#edit-clueOwner").val(data.owner);
					$("#edit-appellation").val(data.appellation);
					$("#edit-job").val(data.job);
					$("#edit-email").val(data.email);
					$("#edit-website").val(data.website);
					$("#edit-phone").val(data.phone);
					$("#edit-mphone").val(data.mphone);
					$("#edit-source").val(data.source);
					$("#edit-state").val(data.state);
					$("#edit-address").val(data.address);
					$("#edit-description").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);

					//显示模态窗口
					$("#editClueModal").modal("show");
				}
			});
		});

		//给保存编辑按钮添加单击事件
		$("#saveEditClueBtn").on("click",function () {


			//获取公司名称
			var company = $.trim($("#edit-company").val());
			if ("" == company) {
				alert("公司名称不能为空");
				return;
			}

			//获取线索名称
			var fullName = $.trim($("#edit-fullName").val());
			if ("" == fullName) {
				alert("线索名称不能为空");
				return;
			}


			var owner = $("#edit-clueOwner").val();

			var id = $("#edit-id").val();
			var appellation = $.trim($("#edit-appellation").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var website = $.trim($("#edit-website").val());
			var phone = $.trim($("#edit-phone").val());
			var mphone = $.trim($("#edit-mphone").val());
			var source = $.trim($("#edit-source").val());
			var state = $.trim($("#edit-state").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $.trim($("#edit-nextContactTime").val());
			var address = $.trim($("#edit-address").val());
			var description = $.trim($("#edit-description").val());

			//发起保存更新请求
			$.ajax({
				url:"workbench/clue/saveEditClue.do",
				type:"post",
				data:{
					id:id,
					owner:owner,
					company:company,
					fullName:fullName,
					appellation:appellation,
					job:job,
					email:email,
					website:website,
					phone:phone,
					mphone:mphone,
					source:source,
					state:state,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					description:description
				},
				success:function (data) {
					if (data.code == 1) {
						//关闭模态窗口
						$("#editClueModal").modal("hide");
						//刷新列表数据
						queryClueList($("#demo_pag1").bs_pagination("getOption","currentPage"),$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert(data.message);
					}

				}
			});

		});

		//给删除按钮添加单击事件
		$("#deleteClueBtn").on("click",function () {
			//获取用户选中的记录对象
			var checkeds = $("#clueList input[type='checkbox']:checked");

			//判断用户选中的是否为0
			if (checkeds.size() == 0) {
				alert("请选择您要删除的记录");
				return;
			}

			if (confirm("您真的要删除吗？")) {

				//准备要删除的记录的id
				var ids = "";

				//循环遍历，拼接
				$.each(checkeds,function (index,obj) {
					ids+="id="+$(obj).val()+"&";
				});

				// alert(ids);
				// alert(ids.substring(0,ids.length-1));

				ids=ids.substring(0,ids.length-1);

				$.ajax({
					url:"workbench/clue/deleteClue.do",
					type:"get",
					data:ids,
					success:function (data) {
						if (data.code == 1) {
							alert("您成功删除" + data.data + "条记录");
							queryClueList(1,$("#demo_pag1").bs_pagination("getOption","rowsPerPage"));
						} else {
							alert(data.message);
						}
					}
				});
			}
		});

	});

	function queryClueList(pageNo,pageSize) {




		$.ajax({
			url:"workbench/clue/queryClueList.do",
			type:"get",
			data:{
				pageNo:pageNo,
				pageSize:pageSize,
				fullName:$.trim($("#query-fullName").val()),
				company:$.trim($("#query-company").val()),
				owner:$.trim($("#query-owner").val()),
				phone:$.trim($("#query-phone").val()),
				mphone:$.trim($("#query-mphone").val()),
				clueStat:$("#query-clueStat").val(),
				source:$("#query-source").val(),
			},
			success:function (data) {
				var htmlStr = "";

				$.each(data.clueList,function (index,obj) {
					htmlStr+="<tr>";
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?id="+obj.id+"';\">"+obj.fullName+"</a></td>";
					htmlStr+="<td>"+obj.company+"</td>";
					htmlStr+="<td>"+obj.phone+"</td>";
					htmlStr+="<td>"+obj.mphone+"</td>";
					htmlStr+="<td>"+obj.source+"</td>";
					htmlStr+="<td>"+obj.owner+"</td>";
					htmlStr+="<td>"+obj.state+"</td>";
					htmlStr+="</tr>";
				});

				$("#clueList").html(htmlStr);

				$("#demo_pag1").bs_pagination({
					currentPage:pageNo,//当前页

					rowsPerPage:pageSize,//每页显示条数
					totalRows:data.totalRows,//总条数
					totalPages:data.totalPage,//总页数

					visiblePageLinks:5,//显示的翻页卡片数

					showGoToPage:true,//是否显示"跳转到第几页"
					showRowsPerPage:true,//是否显示"每页显示条数"
					showRowsInfo:true,//是否显示"记录的信息"

					//每次切换页号都会自动触发此函数，函数能够返回切换之后的页号和每页显示条数
					onChangePage: function(e,pageObj) { // returns page_num and rows_per_page after a link has clicked
						// alert(pageObj.currentPage);
						// alert(pageObj.rowsPerPage);
						queryClueList(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
	}
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
									<option></option>
								  <c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellationList}" var="a">
										<option value="${a.id}">${a.value}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <c:forEach items="${clueStateList}" var="cs">
									  <option value="${cs.id}">${cs.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${sourceList}" var="s">
										<option value="${s.id}">${s.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveCreateClueBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.id}">${a.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullName" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullName" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
									<c:forEach items="${clueStateList}" var="cs">
										<option value="${cs.id}">${cs.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="edit-nextContactTime" value="2017-05-01" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveEditClueBtn" class="btn btn-primary" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="query-fullName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="query-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="query-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="query-source">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="query-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="query-clueStat">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="cs">
							  <option value="${cs.id}">${cs.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="conditionClueListBtn" class="btn btn-default">查询</button>
				  <button type="reset" class="btn btn-default">重置</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editClueBtn" type="button" class="btn btn-default" data-toggle="modal" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteClueBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueList">

					</tbody>
				</table>
			<div id="demo_pag1">
			</div>


			</div>
		</div>
		
	</div>
</body>
</html>