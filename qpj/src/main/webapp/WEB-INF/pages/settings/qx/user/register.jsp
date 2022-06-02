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
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">&nbsp;&nbsp;&nbsp;&nbsp;汽车拼货接单 &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;小组10</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:520px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>注册<small>&nbsp;&nbsp;&nbsp;&nbsp;<a href="settings/qx/user/toLogin.do">登录</a></small></h1>
        </div>
        <form class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码">
                </div>
                <div style="width: 350px; position: relative;top: 40px;">
                    <input class="form-control" type="password" placeholder="确认密码">
                </div>
                <div style="width: 350px; position: relative;top: 60px;">
                    <input class="form-control" type="text" placeholder="手机号码">
                </div>
                <div style="width: 350px; position: relative;top: 80px;">
                    <input class="form-control" type="text" placeholder="个人邮箱">
                </div>
                <div class="checkbox"  style="position: relative;top: 90px; left: 10px;">
                    <label><input type="radio" name="role" value="clent" checked>&nbsp;&nbsp;客户</label>
                    <label><input type="radio" name="role" value="driver">&nbsp;&nbsp;司机</label>
                    <label><input type="radio" name="role" value="admin">&nbsp;&nbsp;管理员</label>
                </div>
                <button type="submit" class="btn btn-primary btn-lg btn-block" style="width: 350px; position: relative;top: 95px;">注册</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>