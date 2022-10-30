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


		//获取当前市场活动的备注列表数据
		queryActivityRemarkList();

		//给保存按钮添加单击事件
		$("#saveCreateRemarkBtn").on("click",function () {

			//获取市场活动备注的数据
			var noteContent = $.trim($("#remark").val());

			//判断备注内容是否为空
			if ("" == noteContent) {
				alert("备注内容不能为空");
				return;
			}

			var activityId = "${activity.id}";

			//发送保存市场活动备注的异步请求
			$.ajax({
				url:"workbench/activity/saveCreateRemark.do",
				type:"post",
				data:{
					activityId:activityId,
					noteContent:noteContent
				},
				success:function (data) {
					if (data.code == 1) {
						$("#remark").val("")
						//刷新备注列表数据
						queryActivityRemarkList();
					} else {
						alert(data.message);
					}
				}
			});
		});

		//给保存编辑按钮添加单击事件
		$("#saveEditRemarkBtn").on("click",function () {
			//获取备注内容
			var noteContent = $.trim($("#edit-noteContent").val());

			//判断备注内容不能为空
			if ("" == noteContent) {
				alert("备注内容不能为空");
				return;
			}

			var id = $("#remarkId").val();

			//发起ajax请求，保存更新的内容
			$.ajax({
				url:"workbench/activity/saveEditRemark.do",
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
						queryActivityRemarkList();
					} else {
						alert(data.message);
					}

				}
			});

		});
	});

	//获取当前市场活动的备注列表数据
	function queryActivityRemarkList() {

		var activityId = "${activity.id}";

		$.ajax({
			url:"workbench/activity/queryActivityRemarkList.do",
			type:"get",
			data:{
				activityId:activityId
			},
			success:function (data) {
				var htmlStr = "";
				var activityName = "${activity.name}";
				$.each(data,function (index,obj) {
					htmlStr+="<div class=\"remarkDiv\" style=\"height: 60px;\">";
					htmlStr+="<img title=\""+obj.createBy+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
					htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
					htmlStr+="<h5>"+obj.noteContent+"</h5>";
					htmlStr+="<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>"+activityName+"</b> <small style=\"color: gray;\"> "+obj.createTime+" 由"+obj.createBy+"</small>";
					htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
					htmlStr+="<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"editRemarkPage('"+obj.id+"','"+obj.noteContent+"')\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
					htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
					htmlStr+="<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"delActivityRemark('"+obj.id+"')\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
					htmlStr+="</div>";
					htmlStr+="</div>";
					htmlStr+="</div>";
				});


				$("#activityRemark").html(htmlStr);
			}
		});
	}

	//显示修改市场活动备注的页面
	function editRemarkPage(id,noteContent) {
		$("#edit-noteContent").val(noteContent);
		$("#remarkId").val(id);
		$("#editRemarkModal").modal("show");
	}

	//删除选中的备注内容
	function delActivityRemark(id) {

		if (confirm("您真的要删除吗？")) {
			$.ajax({
				url:"workbench/activity/delActivityRemark.do",
				type:"post",
				data:{
					id:id
				},
				success:function (data) {
					if (data.code == 1) {
						//刷新列表
						queryActivityRemarkList();
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
	
	<!-- 修改市场活动备注的模态窗口 -->
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
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="activityRemark">

		</div>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>