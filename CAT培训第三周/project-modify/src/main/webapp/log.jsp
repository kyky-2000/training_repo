<%--
  Created by IntelliJ IDEA.
  User: allfather
  Date: 2020/7/28
  Time: 10:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录页面</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <script src="js/jquery-3.3.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>

    <script>
        function refreshCode(){
            $("#vcode").attr("src", "checkCode/getCheckCode?time="+new Date().getTime());
        }
        function login() {
            var checkCode = $("#checkCode").val();
            var mail = $("#mail").val();
            var password = $("#password").val();
            var jsonData = {"mail": mail, "password": password, "checkCode": checkCode};

            $.ajax({
                url: "user/login",
                data: jsonData,
                type: "post",
                dataType: "json",
                success: function(data) {
                    alert(data.msg)
                    // if(data.code == 200) {
                        // alert(data.data.name + "用户， 欢迎您");
                        // sessionStorage.setItem("json", JSON.stringify(data.data));
                        // if(data.data.identity == "管理员"){
                        //     window.location.href = "/manager.jsp";
                        // }else{
                        //     window.location.href = "/home.jsp";
                        // }
                    // }
                    // else
                    //     alert(data.msg);
                }
            });
        }    </script>

</head>

<body>
<form style="width: 600px">
    <div class="form-group">
        <label for="mail">Email address</label>
        <input type="email" class="form-control" id="mail" placeholder="Email">
    </div>
    <div class="form-group">
        <label for="password">Password</label>
        <input type="password" class="form-control" id="password" placeholder="Password">
    </div>
    <div class="form-group">
        <input type="text" name="checkCode" id="checkCode" placeholder="请输入验证码" required="">
        <a href="javascript:refreshCode();">
            <img src="checkCode/getCheckCode" title="看不清点击" id="vcode"/>
        </a>
    </div>
    <button class="btn btn-default" onclick="login()">Submit</button>
    <div class="form-group">
        <a href="findBackPwd.jsp" class="for">找回密码</a>
        <a href="home.jsp" class="for">游客登录</a><br>
        <a href="register.jsp">注册新用户</a>
    </div>
</form>

<%--<form class="form-horizontal">--%>
<%--    <div class="form-group">--%>
<%--        <label for="inputEmail3" class="col-sm-2 control-label">Email</label>--%>
<%--        <div class="col-sm-10">--%>
<%--            <input type="email" class="form-control" id="inputEmail3" placeholder="Email">--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div class="form-group">--%>
<%--        <label for="inputPassword3" class="col-sm-2 control-label">Password</label>--%>
<%--        <div class="col-sm-10">--%>
<%--            <input type="password" class="form-control" id="inputPassword3" placeholder="Password">--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div class="form-group">--%>
<%--        <input type="text" name="checkCode" id="checkCode" placeholder="请输入验证码" required="">--%>
<%--        <a href="javascript:refreshCode();">--%>
<%--            <img src="checkCode/getCheckCode" title="看不清点击" id="vcode"/>--%>
<%--        </a>--%>
<%--    </div>--%>
<%--    <div class="form-group">--%>
<%--        <a href="findBackPwd.jsp" class="for">找回密码</a>--%>
<%--    </div>--%>
<%--    <div class="form-group">--%>
<%--        <div class="col-sm-offset-2 col-sm-10">--%>
<%--            <button type="submit" class="btn btn-default">Sign in</button>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div class="form-group">--%>
<%--        <div class="col-sm-offset-2 col-sm-10">--%>
<%--            <a href="home.jsp" class="for">游客登录</a><br>--%>
<%--            <a href="register.jsp">注册新用户</a>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</form>--%>
</body>
</html>
