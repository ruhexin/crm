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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		$("#remarkDivList").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});
		$("#remarkDivList").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});
		$("#remarkDivList").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		});
		$("#remarkDivList").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});
		//给"关联市场活动"按钮添加单击事件
        $("#bindActivityBtn").click(function () {
        	//清空搜索框
			$("#searchActivityName").val("");
        	//清空搜索列表
			$("#tBody").html("");
            //显示线索关联市场活动的模态窗口
            $("#bindModal").modal("show");
        });


        //获取当前线索的线索备注列表数据
		queryClueRemarkList();

		//给保存备注内容按钮添加单击事件
		$("#saveCreateClueRemark").on("click",function () {
			//获取备注内容
			var noteContent = $.trim($("#remark").val());

			//判断是否为空
			if ("" == noteContent) {
				alert("备注内容不能为空");
				return;
			}

			//获取线索标识
			var clueId = "${clue.id}";

			//保存备注
			$.ajax({
				url:"workbench/clue/saveCreateClueRemark.do",
				type:"post",
				data:{
					clueId:clueId,
					noteContent:noteContent
				},
				success:function (data) {
					if (data.code == 1) {
						//清空备注内容
						$("#remark").val("");
						//刷新列表数据
						queryClueRemarkList();
					} else {
						alert(data.message);
					}
				}
			});

		});

		//给保存更新按钮添加单击事件
		$("#saveEditRemarkBtn").on("click",function () {
			//获取备注内容
			var noteContent = $.trim($("#edit-noteContent").val());
			//判断备注内容是否为空
			if ("" == noteContent) {
				alert("备注内容不能为空");
				return;
			}

			//获取备注的标识
			var id = $("#remarkId").val();

			//发起ajax请求
			$.ajax({
				url:"workbench/clue/saveEditClueRemark.do",
				type:"post",
				data:{
					id:id,
					noteContent:noteContent
				},
				success:function (data) {
					if (data.code == 1) {
						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
						//刷新列表数据
						queryClueRemarkList();
					} else {
						alert(data.message);
					}
				}
			});
		});

		//查询线索关联的市场活动列表数据
		queryClueActivityList();

		//给搜索市场活动名称输入框添加单击事件
		$("#searchActivityName").on("keyup",function () {
			//获取用户输入内容
			var searchActivityName = $.trim($("#searchActivityName").val());

			var clueId = "${clue.id}";
			//发起ajax请求
			$.ajax({
				url:"workbench/clue/queryUnbindClueActivityRelationList.do",
				type:"get",
				data:{
					clueId:clueId,
					searchActivityName:searchActivityName
				},
				success:function (data) {
					var htmlStr = "";

					$.each(data,function (index,obj) {
						htmlStr+="<tr>";
						htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
						htmlStr+="<td>"+obj.name+"</td>";
						htmlStr+="<td>"+obj.startDate+"</td>";
						htmlStr+="<td>"+obj.endDate+"</td>";
						htmlStr+="<td>"+obj.owner+"</td>";
						htmlStr+="</tr>";
					});

					$("#tBody").html(htmlStr);
				}
			});
		});

		//给关联按钮添加单击事件
		$("#saveBindClueActivityRelationBtn").on("click",function () {
			//获取用户选中要关联的记录对象
			var checkeds = $("#tBody input[type='checkbox']:checked");

			//判断选中的数量
			if (checkeds.size() == 0) {
				alert("请选择您要关联的市场活动");
				return;
			}

			var ids="";
			//获取ids
			$.each(checkeds,function (index,obj) {
				ids+="id="+$(obj).val()+"&";
			});

			var clueId = "${clue.id}";
			ids+="clueId="+clueId;

			$.ajax({
				url:"workbench/clue/saveBindClueActivityRelation.do",
				type:"post",
				data:ids,
				success:function (data) {
					if (data.code == 1) {
						alert("您成功关联" + data.data + "条市场活动");
						//关闭模态窗口
						$("#bindModal").modal("hide");
						//刷新已关联数据
						queryClueActivityList();
					} else {
						alert(data.message);
					}
				}
			});
		});

		//给转换按钮添加单击事件
		$("#convertBtn").on("click",function () {
			var clueId = "${clue.id}";
			window.location.href = "workbench/clue/convertPage.do?clueId="+clueId;
		});

	});

	function queryClueRemarkList() {

		//获取当前线索的标识
		var clueId = "${clue.id}";

		//根据线索标识获取线索列表数据
		$.ajax({
			url:"workbench/clue/queryClueRemarkList.do",
			type:"get",
			data:{
				clueId:clueId
			},
			success:function (data) {
				var htmlStr = "";
				var fullName = "${clue.fullName}";
				var appellation = "${clue.appellation}";
				var company = "${clue.company}";
				$.each(data,function (index,obj) {
					htmlStr+="<div class=\"remarkDiv\" style=\"height: 60px;\">";
					htmlStr+="<img title=\""+obj.createBy+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
					htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
					htmlStr+="<h5>"+obj.noteContent+"</h5>";
					htmlStr+="<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>"+fullName+appellation+"-"+company+"</b> <small style=\"color: gray;\"> "+obj.createTime+" 由"+obj.createBy+"</small>";
					htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
					htmlStr+="<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"editRemarkPage('"+obj.id+"','"+obj.noteContent+"')\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
					htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
					htmlStr+="<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"deleteClueRemark('"+obj.id+"')\" ><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
					htmlStr+="</div>";
					htmlStr+="</div>";
					htmlStr+="</div>";
				});

				$("#remarkList").html(htmlStr);
			}
		});

	}

	//跳转至备注编辑页面
	function editRemarkPage(id,noteContent) {
		$("#remarkId").val(id);
		$("#edit-noteContent").val(noteContent);
		//打开模态窗口
		$("#editRemarkModal").modal("show");
	}

	//删除备注内容
	function deleteClueRemark(id) {
		if (confirm("您真的要删除吗？")) {
			$.ajax({
				url:"workbench/clue/deleteClueRemark.do",
				type:"post",
				data:{
					id:id
				},
				success:function (data) {
					if (data.code == 1) {
						//刷新列表
						queryClueRemarkList();
					} else {
						alert(data.message);
					}
				}
			});
		}
	}


	//查询当前线索关联的市场活动列表数据
	function queryClueActivityList() {
		//获取线索标识
		var clueId = "${clue.id}";

		//发起ajax请求
		$.ajax({
			url:"workbench/clue/queryClueActivityList.do",
			type:"get",
			data:{
				clueId:clueId
			},
			success:function (data) {
				var htmlStr = "";

				$.each(data,function (index,obj) {
					htmlStr+="<tr>";
					htmlStr+="<td>"+obj.name+"</td>";
					htmlStr+="<td>"+obj.startDate+"</td>";
					htmlStr+="<td>"+obj.endDate+"</td>";
					htmlStr+="<td>"+obj.owner+"</td>";
					htmlStr+="<td><a href=\"javascript:void(0);\" onclick=\"unbindClueActivityRelation('"+obj.id+"')\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
					htmlStr+="</tr>";
				});

				$("#relationTBody").html(htmlStr);
			}
		});
	}

	//解除线索与市场活动的关系
	function unbindClueActivityRelation(activityId) {
		//获取线索标识
		var clueId = "${clue.id}";

		if (confirm("您真的要解除关系吗？")) {

			$.ajax({
				url:"workbench/clue/unbindClueActivityRelation.do",
				type:"post",
				data:{
					clueId:clueId,
					activityId:activityId
				},
				success:function (data) {
					if (data.code == 1) {
						queryClueActivityList();
					} else {
						alert(data.message);
					}
				}
			});

		}
	}
</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bindModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="searchActivityName" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="saveBindClueActivityRelationBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullName}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="convertBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullName}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<!--作业：显示备注信息-->
		<div id="remarkList">

		</div>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateClueRemark" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="relationTBody">


					</tbody>
				</table>
			</div>
			
			<div>
				<a id="bindActivityBtn" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>