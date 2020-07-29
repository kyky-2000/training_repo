<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <!-- 指定字符集 -->
    <meta charset="utf-8">
    <!-- 使用Edge最新的浏览器的渲染方式 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- viewport视口：网页可以根据设置的宽度自动进行适配，在浏览器的内部虚拟一个容器，容器的宽度与设备的宽度相同。
    width: 默认宽度与设备的宽度相同
    initial-scale: 初始的缩放比，为1:1 -->
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>注册</title>

    <!-- 1. 导入CSS的全局样式 -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. 监听用户输入是否为空 -->
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700" rel="stylesheet">
    <!-- 3. jQuery导入，建议使用1.9以上的版本 -->
    <script src="js/jquery-3.3.1.min.js"></script>
    <!-- 4. 导入bootstrap的js文件 -->
    <script src="js/bootstrap.min.js"></script>
    <!-- 5. 倒计时插件的包 -->
    <script type="text/javascript" src="js/leftTime.min.js"></script>
    <!-- 6. 日期插件-->
    <script src="js/calendar.js" type="text/javascript" language="javascript"></script>

    <script type="text/javascript">
        var mailCode = null;
        var head = null;
        function sendCode() {
            var json = {"mail": $("#mail").val()};
            $.ajax({
                url: "/baseServlet/user/sendMailCode",
                type: "POST",
                data: {"json": JSON.stringify(json)},
                dataType: "json",
                success: function (data) {
                    mailCode = data.data;
                },
                error: function () {
                    alert("服务器繁忙")
                }
            });
        }


        function upload() {
            var formData = new FormData();
            formData.append('file', $('#file')[0].files[0]);
            $.ajax({
                url: 'baseServlet/user/upload',//接受请求的Servlet地址
                type: 'POST',
                data: formData,
                processData:false,
                cache: false,//不缓存页面
                async: true,
                contentType: false,//当form以multipart/form-data方式上传文件时，需要设置为false
                dataType:"json",
                success: function (data) {
                    head = data.data;
                    alert(data.msg);
                },
                error: function () {
                    alert("服务器繁忙，请稍后重试");
                }

            });
        }

        function register(){

            var name = $("#name").val();
            var gender = $(".gender").val();
            var age = $("#age").val();
            var mail = $("#mail").val();
            var lastTeam = $("#lastTeam").val();
            var code = $("#code").val();
            var profile = $("#profile").val();
            var password = $("#password").val();
            var identity = $(".identity").val();
            var joinDate = $("#joinDate").val();
            var mailCode1 = $("#mailCode").val();

            var json = {"head":head, "name":name, "gender":gender, "age":age, "mail":mail, "lastTeam":lastTeam,
                "code":code, "profile":profile, "password":password, "identity":identity, "joinDate": joinDate,
                "mailCode1": mailCode1, "mailCode2": mailCode};

            $.ajax({
                url: "/user/register",
                data: 'json',
                type:"POST",
                dataType: "json",
                success: function (data) {
                    alert(data.msg);
                },
                error: function () {
                    alert("服务器繁忙");
                }
            });
        }



        $(function(){

            //监听邮箱输入框是否失去焦点
            $("#mail").blur(function () {
                if (checkEMail($(this)) == true) {
                    $("#dateBtn1").attr("disabled", false);
                } else {
                    alert("账号非邮箱地址！");
                }
            });
            //检验邮箱格式是否正确
            function checkEMail(e){
                var reEml = /^[\w\-\.]+@[a-z0-9]+(\-[a-z0-9]+)?(\.[a-z0-9]+(\-[a-z0-9]+)?)*\.[a-z]{2,4}$/i;
                if(reEml.test(e.val())){
                    return true;
                }else{
                    return false;
                }
            }
            //监听获取邮件验证码的按钮是否处于倒计时
            $("#dateBtn1").on("click",function(){
                var _this=$(this);
                sendCode();
                $("#dateBtn1").attr("disabled", true);
                if(!$(this).hasClass("on")){
                    $.leftTime(60,function(d){
                        if(d.status){
                            _this.addClass("on");
                            _this.html((d.s=="00"?"60":d.s)+"秒后重新获取");
                        }else{
                            _this.removeClass("on");
                            _this.html("获取验证码");
                            $("#dateBtn1").attr("disabled", false);
                        }
                    });
                }
            });
        })
    </script>
</head>
<body>
<div class="container">
    <div style="text-align: center;"><h3>注册新用户</h3></div>
    <form action="" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <form id="uploadForm" method="post" enctype="multipart/form-data">
                <label>靓仔，传张照片吧，听说颜值高的人比较抢手哦</label>
                <input type="file" name="file" id="file" required=""/>
                <input type="submit" value="上传" onclick="upload()">
            </form>
        </div>
        <div class="form-group">
            <label for="name">姓名：</label>
            <input type="text" class="form-control" id="name" name="name" placeholder="请输入真实姓名" required=""/>
        </div>

        <div class="form-group">
            <label>性别：</label>
            <input type="radio" name="gender" class="gender" value="男" checked="checked"/>男
            <input type="radio" name="gender" class="gender" value="女"/>女
        </div>

        <div class="form-group">
            <label for="age">年龄：</label>
            <input type="text" class="form-control" id="age" name="age" placeholder="请输入年龄" required=""/>
        </div>
        <div class="form-group">
            <label for="lastTeam">效力的上一支队伍：</label>
            <input type="text" class="form-control" id="lastTeam" name="lastTeam" placeholder="请输入您效力的上一支队伍" required=""/>
        </div>
        <div class="form-group">
            <label for="mail">邮箱：</label>
            <div class="input-group">
                <input type="text" class="form-control" id="mail" name="mail" placeholder="请输入正确的邮箱">
            </div><!-- /input-group -->
        </div><!-- /.col-lg-6 -->
        <button type="button" class="testBtn-a" id="dateBtn1" disabled="true" style="display: inline-block;height:30px;line-height:30px;
        padding:0 10px;border:0; border-radius:5px;color:#fff;background:rgb(65,133,244);cursor: pointer" >获取验证码</button>
        <div class="form-group">
            <label for="mailCode">验证码</label>
            <input type="text" class="form-control" id="mailCode" name="mailCode" placeholder="请输入验证码" required=""/>
        </div>
        <div class="form-group">
            <label for="password">密码</label>
            <input type="text" class="form-control" id="password" name="password" placeholder="请输入密码" required=""/>
        </div>
        <div class="form-group">
            <label for="joinDate">加入LPL时间</label>
            <input type="text" class="form-control" id="joinDate" name="joinDate" placeholder="2020-02-02"
                   onclick="SetDate(this,'yyyy-MM-dd')" readonly="readonly" required=""/>
        </div>
        <div class="form-group">
            <label>身份</label>
            <input type="radio" name="identity" class="identity" value="战队管理层" checked="checked"/>战队管理层
            <input type="radio" name="identity" class="identity" value="职业选手"/>职业选手
        </div>
        <div class="form-group">
            <label for="profile">个人简介</label>
            <textarea class="form-control" id="profile" name="profile" rows="4" placeholder="介绍一下自己吧"></textarea>
        </div>
        <div class="form-group" style="text-align: center">
            <input class="btn btn-primary" id="submit" type="submit" value="提交" onclick="register();"/>
            <a href="${pageContext.request.contextPath}/login.jsp"><input class="btn btn-default" type="button" value="返回" /></a>
        </div>
    </form>
</div>
</body>
</html>
