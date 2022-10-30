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
<script type="text/javascript">
	$(function () {

		//给“编码”输入框添加失去焦点事件
		$("#create-code").on("blur",function () {
			//获取编码
			var createCode = $.trim($("#create-code").val());

			//判断是否为空
			if ("" == createCode) {
				$("#codeMsg").text("请输入数据字典类型编码");
				return;
			}

			//验证数据字典类型编码是否为重复
			//发送ajax异步请求
			$.ajax({
				url:"settings/dictionary/type/checkCode.do",
				type:"get",
				data:{
					code:createCode
				},
				success:function (data) {
					if (data.code == 1) {
						$("#codeMsg").text("");
					} else {
						$("#codeMsg").text(data.message);
					}
				}
			});
		});


		//给保存按钮添加单击事件
		$("#saveCreateDicTypeBtn").on("click",function () {

			//让其失去焦点的方法
			$("#create-code").blur();

			//获取类型编码错误的提示内容
			var codeMsg = $("#codeMsg").text();

			//判断类型编码是否验证通过
			if ("" != codeMsg) {
				return;
			}

			//获取提交的参数
			var code = $("#create-code").val().trim();
			var name = $("#create-name").val().trim();
			var description = $("#create-description").val().trim();

			//发起ajax请求
			$.ajax({
				url:"settings/dictionary/type/saveCreateDicType.do",
				type:"post",
				data:{
					code:code,
					name:name,
					description:description
				},
				success:function (data) {
					if (data.code == 1) {
						//跳转至列表页面
						window.location.href = "settings/dictionary/type/index.do";
					} else {
						alert(data.message);
					}
				}
			});

		});

	});
</script>

</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveCreateDicTypeBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-code" style="width: 200%;">
				<span id="codeMsg" style="color: red"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" rows="3" id="create-description" style="width: 200%;"></textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>