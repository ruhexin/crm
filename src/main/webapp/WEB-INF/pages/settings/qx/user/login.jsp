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
$(function () {

	//从cookie中获取帐号和密码
	//alert(document.cookie);loginAct=ls; loginPwd=ls
	var cookiesArray = document.cookie.split(";");

	var loginAct = "";
	var loginPwd = "";

	//循环遍历cookiesArray数组
	for (var i = 0; i < cookiesArray.length; i++) {
		//获取数组元素后通过=号进行分隔之后的数组，取数组的第1个
		var k = cookiesArray[i].split("=")[0].trim();

		//判断是否为获取的key
		if ("loginAct" == k) {
			loginAct = cookiesArray[i].split("=")[1];
			continue;
		}


		if ("loginPwd" == k) {
			loginPwd = cookiesArray[i].split("=")[1];
		}
	}

	// alert(loginAct+"==="+loginPwd);


	if ("" != loginAct && "" != loginPwd) {
		$("#loginAct").val(loginAct);
		$("#loginPwd").val(loginPwd);
		//勾选“记住密码”
		$("#isRemPwd").prop("checked", true);
	} else {
		$("#isRemPwd").prop("checked", false);
	}





	//给整个页面添加键盘按下的事件
	$(window).keydown(function (e) {
		//如果按的是回车键，发送请求
		if(e.keyCode==13){
			$("#loginBtn").click();
		}
	});
	//给"登录"按钮添加单击事件
	$("#loginBtn").click(function () {
		//window.location.href="workbench/index.do";
		//登录请求需要的是局部刷新->异步请求->ajax
		//ajax包含常用的属性：url、data、type（get[查询使用]、post[增、删、改]）、dataType、success

		//获取用户登录的信息
		var loginAct = $.trim($("#loginAct").val());
		//获取的用户密码是一个明文：加密之前的字符串
		var loginPwd = $.trim($("#loginPwd").val());

		//判断用户名和密码不能为空
		if ("" == loginAct || "" == loginPwd) {
			$("#msg").text("用户名或密码不能为空");
			//如果验证不通过，那么请求不应该再往下继续执行
			return;
		}

		//获取用户是否要记住密码的状态
		var isRemPwd = $("#isRemPwd").prop("checked");

		$.ajax({
			url:"settings/qx/user/login.do",//请求地址
			type:"get",//请求方式,get和post：表单通过使用post；get请求参数在地址栏中可以看到，post地址栏中看不到请求参数；get请求参数是有长度限制的，而post则没有
			data:{
				loginAct:loginAct,
				loginPwd:loginPwd,
				isRemPwd:isRemPwd
			},//请求参数，格式：1.k=v&k1=v1&k2=v2&..... 2.JSON数据格式
			// dataType:"",//指定响应的数据类型【可选】
			success:function (data) {//后台处理成功之后的处理函数：响应参数格式为：json
				//后台响应JSON数据格式为：
				//登录是否成功的结果
					//成功：跳转到工作台首页面
					//失败：提示消息
				//{"key":value,"key":value}
				//alert("======"+data.code);
				if (data.code == 1) {
					//成功：跳转到工作台首页面
					window.location.href="workbench/index.do";
				} else {
					//失败：提示消息
					$("#msg").text(data.message);
				}
			}
		});
	});
});

/*$(function () {

});
//等同于
$(document).ready(function () {

});	*/
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
	</div>

	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct"  type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
								<input type="checkbox" id="isRemPwd" >
							记住密码
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="color: red"></span>
					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>