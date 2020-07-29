<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>个人主页</title>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="theme/css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="theme/js/jquery-3.3.1.min.js"></script>
    <!-- 3. 导入bootstrap的js文件 -->
    <script src="theme/js/bootstrap.min.js"></script>
    <!-- 4. 监听输入是否为空-->
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700" rel="stylesheet">
    <!-- 5. 日期插件-->
    <script src="theme/js/calendar.js" type="text/javascript" language="javascript"></script>
    <title>Title</title>

    <script>
        function update(){

            var name = $("#name").val();
            var gender = $(".gender").val();
            var age = $("#age").val();
            var lastTeam = $("#lastTeam").val();
            var profile = $("#profile").val();
            var password = $("#password").val();
            var joinDate = $("#joinDate").val();

            var json = {"name":name, "gender":gender, "age":age, "lastTeam":lastTeam, "profile":profile,
                "password":password, "joinDate": joinDate,};

            $.ajax({
                url: "baseServlet/user/update",
                data: {"json" : JSON.stringify(json)},
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
    </script>
</head>
<body>
<div class="container" style="width: 400px;">
    <h3 style="text-align: center;">修改信息</h3>
    <form method="post">
        <!--  隐藏域 提交id-->
        <input type="hidden" name="id" value="${user.ID}">
        <div class="form-group">
            <label for="name">姓名：</label>
            <input type="text" class="form-control" id="name" name="name"  value="${user.name}" readonly="readonly" placeholder="请输入姓名" />
        </div>
        <div class="form-group">
            <label>性别：</label>
            <c:if test="${user.gender == '男'}">
                <input type="radio" name="gender" id="gender" value="男" checked />男
                <input type="radio" name="gender" id="gender" value="女"  />女
            </c:if>
            <c:if test="${user.gender == '女'}">
                <input type="radio" name="gender" id="gender" value="男"  />男
                <input type="radio" name="gender" id="gender" value="女" checked  />女
            </c:if>
        </div>
        <div class="form-group">
            <label for="age">年龄：</label>
            <input type="text" class="form-control" id="age" value="${user.age}" id="age"  name="age" placeholder="请输入年龄" />
        </div>
        <div class="form-group">
            <label for="password">密码：</label>
            <input type="text" id="password" class="form-control" value="${user.password}" name="password" placeholder="请输入新密码"/>
        </div>
        <div class="form-group">
            <label for="joinDate">加入LPL时间:</label>
            <input type="text" class="form-control" id="joinDate" name="joinDate" value="${user.joinDate}" placeholder="${user.joinDate}"
                   onclick="SetDate(this,'yyyy-MM-dd')" readonly="readonly" required=""/>
        </div>
        <div class="form-group">
            <label for="lastTeam">上一支战队：</label>
            <input type="text" id="lastTeam" class="form-control" value="${user.lastTeam}" name="lastTeam" placeholder="加入的上一支战队"/>
        </div>
        <div class="form-group">
            <label for="profile">个人简介：</label>
            <input type="text" id="profile" class="form-control" value="${user.profile}" name="profile"/>
        </div>
        <div class="form-group" style="text-align: center">
            <input class="btn btn-primary" type="submit" value="提交" onclick="update()"/>
            <a href="${pageContext.request.contextPath}/person_page.jsp"><input class="btn btn-default" type="button" value="返回"/></a>
        </div>
    </form>
</div>
</body>
</html>
