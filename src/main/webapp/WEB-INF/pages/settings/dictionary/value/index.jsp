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

		//查询所有数据字典值列表数据
		queryAllDicValueList();

		//给创建按钮添加单击事件
		$("#createDicValueBtn").on("click",function () {
			//跳转至新增页面
			window.location.href = "settings/dictionary/value/createDicValuePage.do";
		});

		//给编辑按钮添加单击事件
		$("#editDicValueBtn").on("click",function () {

			//获取选中的记录对象
			var checkeds = $("#tBody input[type='checkbox']:checked");

			//判断选中记录对象的数量
			if (checkeds.size() != 1) {
				alert("一次只能编辑一条记录");
				return;
			}

			//获取选中对象的标识
			var id = checkeds.val();

			//发送同步请求，实现页面的跳转
			window.location.href = "settings/dictionary/value/editDicValuePage.do?id="+id;

		});


		//给删除按钮添加单击事件
		$("#deleteDicValueBtn").on("click",function () {
			//获取选中的记录对象
			var checkeds = $("#tBody input[type='checkbox']:checked");

			//获取选中记录对象的数量
			//判断数量
			if (checkeds.size() == 0) {
				alert("请选择要删除的记录");
				return;
			}

			if (confirm("您真的要删除吗？")) {

				var ids = "";

				//循环遍历，获取对象的value属性值
				$.each(checkeds,function (index,obj) {
					ids+="id="+$(obj).val()+"&";
				});

				ids = ids.substring(0,ids.length-1);

				//发送删除的请求
				$.ajax({
					url:"settings/dictionary/value/deleteDicValue.do",
					type:"get",
					data:ids,//id=1&id=2&id=3&....
					success:function (data) {
						if (data.code == 1) {
							alert("您成功删除"+data.data+"条记录");
							queryAllDicValueList();
						} else {
							alert(data.message);
						}
					}
				});

			}



		});

	});

	//查询所有数据字典值列表数据
	function queryAllDicValueList() {
		$.ajax({
			url:"settings/dictionary/value/queryAllDicValueList.do",
			type:"get",
			success:function (data) {
				var htmlStr = "";

				$.each(data,function (index,obj) {
					if (index % 2 == 0) {
						htmlStr += "<tr class=\"active\">";
					} else {
						htmlStr += "<tr>";
					}
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="<td>"+(index+1)+"</td>";
					htmlStr+="<td>"+obj.value+"</td>";
					htmlStr+="<td>"+obj.text+"</td>";
					htmlStr+="<td>"+obj.orderNo+"</td>";
					htmlStr+="<td>"+obj.typeCode+"</td>";
					htmlStr+="</tr>";
				});

				$("#tBody").html(htmlStr);
			}
		});
	}
</script>

</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button id="createDicValueBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button id="editDicValueBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button id="deleteDicValueBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" /></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="tBody">


			</tbody>
		</table>
	</div>
	
</body>
</html>