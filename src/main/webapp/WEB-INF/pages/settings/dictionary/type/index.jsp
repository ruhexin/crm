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
	/*$(document).ready(function () {

	});*/
	$(function () {
		//获取数据字典类型列表的数据
		queryAllDicTypeList();

		//给checkedAll添加单击事件
		$("#checkedAll").on("click",function () {
			//tBody里面的多选框的状态值应跟checkedAll多选框的状态值保持一致
			$("#tBody input[type='checkbox']").prop("checked",$("#checkedAll").prop("checked"));
		});


		//多选框的反选功能
		/*$("#tBody input[type='checkbox']").on("click",function () {
			alert("----");
		});*/

		//给新增按钮添加单击事件
		$("#createDicTypeBtn").on("click",function () {
			window.location.href = "settings/dictionary/type/createDicTypePage.do";
		});

		//给编辑按钮添加单击事件
		$("#editDicTypeBtn").on("click",function () {
			//获取用户选中的记录
			var checkeds = $("#tBody input[type='checkbox']:checked");

			//判断用户选中记录的条数
			if (1 != checkeds.length) {
				alert("一次只能编辑一条记录");
				return;
			}

			//获取选中对象的code编码
			var code = $("#tBody input[type='checkbox']:checked").val();
			//发送同步请求
			window.location.href = "settings/dictionary/type/editDicTypePage.do?code="+code;
		});

		//给删除添加单击事件
		$("#deleteDicTypeBtn").on("click",function () {
			//获取用户选中删除对象
			var checkeds = $("#tBody input[type='checkbox']:checked");

			//获取用户选中删除对象的数量
			var checkedCount = checkeds.size();

			//判断删除对象的数量
			if (0 == checkedCount) {
				alert("请选择要删除的记录");
				return;
			}

			if (confirm("您真的要删除吗？")) {
				//获取删除对象的code值
				var codes = "";
				//循环遍历获取到的选中对象
				$.each(checkeds,function (index,obj) {
					var code = $(obj).val();
					codes += "code="+code+"&";
				});

				// alert(codes.substring(0,codes.length-1));
				codes = codes.substring(0,codes.length-1);

				//发送删除的异步请求
				$.ajax({
					url:"settings/dictionary/type/deleteDicType.do",
					type:"get",
					data:codes,//code=1&code=2&code=3&....
					success:function (data) {
						if (data.code == 1) {
							alert("您成功删除" + data.data + "条记录");
							//刷新列表数据
							queryAllDicTypeList();
						} else {
							alert(data.message);
						}
					}
				});
			}


		});
	});

	//获取数据字典类型列表的数据
	function queryAllDicTypeList() {
		//发送ajax请求
		$.ajax({
			url:"settings/dictionary/type/queryAllDicTypeList.do",
			type:"get",
			success:function (data) {

				//创建html字符串变量
				var htmlStr = "";

				//循环遍历data集合
				$.each(data,function (index,obj) {
					if (index % 2 == 0) {
						htmlStr += "<tr class=\"active\">";
					} else {
						htmlStr += "<tr>";
					}

					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.code+"\" onclick=\"checkAll()\"/></td>";
					htmlStr+="<td>"+(index+1)+"</td>";
					htmlStr+="<td>"+obj.code+"</td>";
					htmlStr+="<td>"+obj.name+"</td>";
					htmlStr+="<td>"+obj.description+"</td>";
					htmlStr+="</tr>";
				});

				//将拼接好的html字符串添加到tbody标签中
				$("#tBody").html(htmlStr);
			}
		});


	}

	//多选框的反选功能
	function checkAll() {
		//获取到所有选中的对象和列表中的数据条件比较
		if ($("#tBody input[type='checkbox']:checked").size() == $("#tBody input[type='checkbox']").size()) {
			$("#checkedAll").prop("checked", true);
		} else {
			$("#checkedAll").prop("checked", false);

		}
	}

</script>

</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button id="createDicTypeBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button id="editDicTypeBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button id="deleteDicTypeBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkedAll"/></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="tBody">

			</tbody>
		</table>
	</div>
	
</body>
</html>