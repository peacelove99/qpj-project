<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
		//给整个浏览器窗口添加键盘按下事件
		$(window).keydown(function (e) {
			//如果按的是回车键，则提交登录请求
			if(e.keyCode==13){
				$("#loginBtn").click();
			}
		});

		//给"登录"按钮添加单击事件
		$("#loginBtn").click(function () {
			//收集参数
			var name=$.trim($("#name").val());
			var password=$.trim($("#password").val());
			var isRemPwd=$("#isRemPwd").prop("checked");
			var role=$("#checkbox input[type='radio']:checked").val();
			//客户:clent 司机:driver 管理员:admin

			//表单验证
			if (name=="") {
				alert("用户名不能为空");
				return;
			}
			if (password=="") {
				alert("密码不能为空");
				return;
			}

			//发送请求
			$.ajax({
				url:"settings/qx/user/Login.do",
				data:{
					Name:name,
					Password:password,
					isRemPwd:isRemPwd,
					role:role
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if (data.code=="1"){
						//跳转到业务主页面
						window.location.href="workbench/index.do";
					}else {
						//提示信息
						$("#msg").text(data.message);
					}
				},
				beforeSend:function () {//当ajax向后台发送请求之前，会自动执行本函数；
					//该函数的返回值能够决定ajax是否真正向后台发送请求：
					//如果该函数返回true,则ajax会真正向后台发送请求；否则，如果该函数返回false，则ajax放弃向后台发送请求。
					$("#msg").text("正在努力验证....");
					return true;
				}
			});
		});

	});
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">&nbsp;&nbsp;&nbsp;&nbsp;汽车拼货接单 &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;小组10</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录<small>&nbsp;&nbsp;&nbsp;&nbsp;<a href="settings/qx/user/toRegister.do">注册</a></small></h1>
			</div>
			<form class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="name" type="text" value="${cookie.cName.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="password" type="password" value="${cookie.cPassword.value}" placeholder="密码">
					</div>

					<div class="checkbox" id="checkbox" style="position: relative;top: 30px; left: 10px;">
						<c:if test="${cookie.role == 'clent'}">
							<label><input type="radio" name="role" value="clent" checked>&nbsp;&nbsp;客户</label>
							<label><input type="radio" name="role" value="driver">&nbsp;&nbsp;司机</label>
							<label><input type="radio" name="role" value="admin">&nbsp;&nbsp;管理员</label>
						</c:if>
						<c:if test="${cookie.role == 'driver'}">
							<label><input type="radio" name="role" value="clent">&nbsp;&nbsp;客户</label>
							<label><input type="radio" name="role" value="driver" checked>&nbsp;&nbsp;司机</label>
							<label><input type="radio" name="role" value="admin">&nbsp;&nbsp;管理员</label>
						</c:if>
						<c:if test="${cookie.role == 'driver'}">
							<label><input type="radio" name="role" value="clent">&nbsp;&nbsp;客户</label>
							<label><input type="radio" name="role" value="driver">&nbsp;&nbsp;司机</label>
							<label><input type="radio" name="role" value="admin" checked>&nbsp;&nbsp;管理员</label>
						</c:if>
						<br><br>
						<label>
							<c:if test="${not empty cookie.Name and not empty cookie.Password}">
								<input type="checkbox" id="isRemPwd" checked>
							</c:if>
							<c:if test="${empty cookie.Name or empty cookie.Password}">
								<input type="checkbox" id="isRemPwd">
							</c:if>
							十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="color: red"></span>
					</div>
					<button type="button" id="loginBtn"  class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>