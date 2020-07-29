<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <title>登录</title>

    <link href="css/style.css" rel='stylesheet' type='text/css' media="all">
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700" rel="stylesheet">
    <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
    <script>
        addEventListener("load", function () { setTimeout(hideURLbar, 0); }, false); function hideURLbar() { window.scrollTo(0, 1); }

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
                type: "POST",
                dataType: "json",
                success: function(data) {
                    alert(data.msg);
                    if(data.code == 200) {
                        alert(data.data.name + "用户， 欢迎您");
                        if(data.data.identity == "管理员"){
                            window.location.href = "/manager.jsp";
                        }else{
                            window.location.href = "/home.jsp";
                        }
                    }
                    else
                        alert(data.msg);
                }
            });
        }
    </script>

</head>
<body>
    <div class="mid-class">
        <div class="art-right-w3ls">
            <h2>欢迎您</h2>
            <form method="post">
                <div class="main">
                    <div class="form-left-to-w3l">
                        <input type="text" name="mail" id="mail" placeholder="账号" required="">
                    </div>
                    <div class="form-left-to-w3l ">
                        <input type="password" name="password" id="password" placeholder="密码" required="">
                        <div class="clear"></div>
                    </div>
                    <div class="form-left-to-w31">
                        <input type="text" name="checkCode" id="checkCode" placeholder="请输入验证码" required="">
                        <a href="javascript:refreshCode();">
                            <img src="checkCode/getCheckCode" title="看不清点击" id="vcode"/>
                        </a>
                    </div>
                </div>
                <div class="right-side-forget" style="float: left;">
                    <a href="${pageContext.request.contextPath}/findBackPwd.jsp" class="for">找回密码</a>
                </div>
                <div class="right-side-forget">
                    <a href="${pageContext.request.contextPath}/home.jsp" class="for">游客登录</a>
                </div>
                <div class="clear"></div>
                <div class="btnn">
                    <button id="btnn-login" onclick="login();" >登录</button>
                </div>
            </form>
            <div class="w3layouts_more-buttn">
                <h3>您当前还没有用户吗?
                    <a href="register.jsp">注册新用户
                    </a>
                </h3>
            </div>
        </div>
    </div>
</body>
</html>