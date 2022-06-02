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
        //给"注册"按钮添加单击事件
        $("#registerBtn").click(function () {
            //收集参数
            var name=$.trim($("#name").val());
            var pwd=$.trim($("#pwd").val());
            var rePwd=$.trim($("#rePwd").val());
            var phone=$.trim($("#phone").val());
            var email=$.trim($("#email").val());
            var role=$("#checkbox input[type='radio']:checked").val();
            //客户:clent 司机:driver 管理员:admin
            //表单验证
            if(name==""){
                alert("用户名不能为空");
                return;
            }
            if(pwd==""){
                alert("密码不能为空");
                return;
            }
            if(pwd!=rePwd){
                alert("两次密码不一样");
                return;
            }
            if(phone==""){
                alert("电话不能为空");
                return;
            }
            if(email==""){
                alert("邮箱不能为空");
                return;
            }
            //发送请求
            $.ajax({
                url:"settings/qx/user/Register.do",
                data:{
                    Name:name,
                    Password:pwd,
                    Phone:phone,
                    Email:email,
                    role:role
                },
                type:'post',
                dataType:'json',
                //注册成功之后,跳转到登录页面
                success:function (data) {
                    if(data.code=="1"){
                        window.location.href = "settings/qx/user/toLogin.do";
                    }else{
                        //注册失败,提示信息注册失败
                        //提示信息
                        alert(data.message);
                    }
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

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:550px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>注册<small>&nbsp;&nbsp;&nbsp;&nbsp;<a href="settings/qx/user/toLogin.do">登录</a></small></h1>
        </div>
        <form class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" id="name" type="text" placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" id="pwd" type="password" placeholder="密码">
                </div>
                <div style="width: 350px; position: relative;top: 40px;">
                    <input class="form-control" id="rePwd" type="password" placeholder="确认密码">
                </div>
                <div style="width: 350px; position: relative;top: 60px;">
                    <input class="form-control" id="phone" type="text" placeholder="手机号码">
                </div>
                <div style="width: 350px; position: relative;top: 80px;">
                    <input class="form-control" id="email" type="text" placeholder="个人邮箱">
                </div>
                <div class="checkbox" id="checkbox" style="position: relative;top: 90px; left: 10px;">
                    <label><input type="radio" name="role" value="clent" checked>&nbsp;&nbsp;客户</label>
                    <label><input type="radio" name="role" value="driver">&nbsp;&nbsp;司机</label>
                    <label><input type="radio" name="role" value="admin">&nbsp;&nbsp;管理员</label>
                </div>
                <button type="button" id="registerBtn" class="btn btn-primary btn-lg btn-block" style="width: 350px; position: relative;top: 95px;">注册</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>