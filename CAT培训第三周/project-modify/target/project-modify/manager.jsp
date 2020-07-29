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
    <title>后台管理系统</title>

    <!-- 1. 导入CSS的全局样式 -->
    <link href="theme/css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="theme/js/jquery-3.3.1.min.js"></script>
    <!-- 3. 导入bootstrap的js文件 -->
    <script src="theme/js/bootstrap.min.js"></script>

    <script>
        function userRegister(){
            var json = {"status": "未通过"};
            $.ajax({
                url: "baseServlet/manager/searchUsers",
                type: "POST",
                data: {"json": JSON.stringify(json)},
                dataType: "json",
                success: function (data) {
                    var users = data.data;
                    for(var i in users){
                        var user = users[i];
                        $("#users").append("<tr class=\"success\">\n" +
                            "            <td>"+user.ID+"</td><td>"+user.name+"</td><td>"+user.gender+"</td><td>"+user.age+"</td><td>"+user.mail+"</td><td>"+user.lastTeam+"</td><td>"+user.joinDate+"</td><td>"+user.identity+"</td><td>"+user.profile+"</td>\n" +
                            "        <td><a class=\"btn btn-default btn-sm\" onclick='updateInfo("+user.ID+", \"正常\", \"User\")'>通过</a>&nbsp;\n" +
                            "                    <a class=\"btn btn-default btn-sm\" onclick='deleteInfo("+user.ID+", \"User\")'>驳回</a></td> + </tr>")
                    }

                }
            });

            accusation();
        }
        function accusation() {
            var json = {"status": "被举报"};
            $.ajax({
                url: "baseServlet/manager/searchUsers",
                type: "POST",
                data: {"json": JSON.stringify(json)},
                dataType: "json",
                success: function (data) {
                    var users = data.data;
                    for(var i=0; i<users.length; ++i){
                        var user = users[i];
                        $("#accusation").append("<tr class=\"success\">\n" +
                            "            <td>"+user.ID+"</td><td>"+user.name+"</td><td>"+user.gender+"</td><td>"+user.age+"</td><td>"+user.mail+"</td><td>"+user.lastTeam+"</td><td>"+user.joinDate+"</td><td>"+user.identity+"</td><td>"+user.profile+"</td>\n" +
                            "        <td><a class=\"btn btn-default btn-sm\" onclick='updateInfo("+user.ID+", \"封禁\", \"User\")'>封禁</a>&nbsp;\n" +
                            "                    <a class=\"btn btn-default btn-sm\" onclick='updateInfo("+user.ID+", \"正常\", \"User\")'>驳回</a></td> + </tr>")
                    }

                }
            });
            information();
        }
        function information() {
            var json = {"status": "未通过"};
            $.ajax({
                url: "baseServlet/manager/searchInfo",
                type: "POST",
                data: {"json": JSON.stringify(json)},
                dataType: "json",
                success: function (data) {
                    var information = data.data;
                    for(var i=0; i<information.length; ++i){
                        var  info =  information[i];
                        $("#info").append("<tr class=\"success\">\n" +
                            "            <td>"+info.ID+"</td><td>"+info.name+"</td><td>"+info.gameCareer1+"</td><td>"+info.gameCareer2+"</td><td>"+info.gameCareer3+"</td><td>"+info.salary+"</td><td>"+info.introduce+"</td>\n" +
                            "        <td><a class=\"btn btn-default btn-sm\" onclick='updateInfo("+info.ID+", \"正常\", \"Info\")'>通过</a>&nbsp;\n" +
                            "                    <a class=\"btn btn-default btn-sm\" onclick='deleteInfo("+info.ID+", \"Info\")'>驳回</a></td> + </tr>")
                    }

                }
            });
            auction();
        }
        function auction() {
            var json = {"status": "申请拍卖"};
            $.ajax({
                url: "baseServlet/manager/searchInfo",
                type: "POST",
                data: {"json": JSON.stringify(json)},
                dataType: "json",
                success: function (data) {
                    var information = data.data;
                    for(var i=0,I=information.length; i<I; ++i){
                        var  info =  information[i];
                        $("#info").append("<tr class=\"success\">\n" +
                            "            <td>"+info.ID+"</td><td>"+info.name+"</td><td>"+info.gameCareer1+"</td><td>"+info.gameCareer2+"</td><td>"+info.gameCareer3+"</td><td>"+info.salary+"</td><td>"+info.introduce+"</td>\n" +
                            "        <td><a class=\"btn btn-default btn-sm\" onclick='updateInfo("+info.ID+", \"拍卖\", \"Info\")'>通过</a>&nbsp;\n" +
                            "                    <a class=\"btn btn-default btn-sm\" onclick='deleteInfo("+info.ID+", \"Info\")'>驳回</a></td> + </tr>")
                    }

                }
            })
        }

        function deleteInfo(ID, name){
            if(confirm("您确定要删除该用户吗？") == false){
                return;
            }
            var json = {"ID": ID+"", "name": name};
            $.ajax({
                url: "baseServlet/manager/delete",
                type: "POST",
                data: {"json": JSON.stringify(json)},
                dataType: "json",
                success: function (data) {
                    alert(data.msg);
                    $(this).remove();
                },
                error:function () {
                    alert("服务器繁忙");
                }
            })
        }
        function updateInfo(ID, status, name) {
            if(confirm("您确认此操作吗？") == false){
                return;
            }
            var json = {"ID": ID+"", "status": status, "name": name};
            $.ajax({
                url: "baseServlet/manager/update",
                type: "POST",
                data: {"json": JSON.stringify(json)},
                dataType: "json",
                success: function (data) {
                    alert(data.msg);
                    $(this).parent().parent().hide();
                },
                error:function () {
                    alert("服务器繁忙");
                }
            })
        }
    </script>
</head>
<body onload="userRegister()">
<div class="container">
    <h3 style="text-align: center">用户注册列表</h3>
    <form id="registerForm" method="post">
         <table border="1" class="table table-bordered table-hover" id="users">
            <tr class="success">
                <th>编号</th>
                <th>姓名</th>
                <th>性别</th>
                <th>年龄</th>
                <th>邮箱</th>
                <th>上一支战队</th>
                <th>加入LPL时间</th>
                <th>注册身份</th>
                <th>个人简介</th>
                <th>操作</th>
            </tr>
        </table>
    </form>
    <br><hr><br>
    <h3 style="text-align: center">用户违规列表</h3>
    <form id="accusationForm" method="post">
        <table border="1" class="table table-bordered table-hover" id="accusation">
            <tr class="success">
                <th>编号</th>
                <th>姓名</th>
                <th>性别</th>
                <th>年龄</th>
                <th>邮箱</th>
                <th>上一支战队</th>
                <th>加入LPL时间</th>
                <th>注册身份</th>
                <th>个人简介</th>
                <th>操作</th>
            </tr>
        </table>
    </form>
    <br><hr><br>
    <h3 style="text-align: center">转会申请表</h3>
    <form id="infoForm" method="post">
        <table border="1" class="table table-bordered table-hover" id="info">
            <tr class="success">
                <th>编号</th>
                <th>姓名</th>
                <th>职业一</th>
                <th>职业二</th>
                <th>职业三</th>
                <th>预想年薪</th>
                <th>自我介绍</th>
                <th>操作</th>
            </tr>
        </table>
    </form>
    <br><hr><br>
    <h3 style="text-align: center">拍卖申请表</h3>
    <form id="auctionForm" method="post">
        <table border="1" class="table table-bordered table-hover" id="auction">
            <tr class="success">
                <th>编号</th>
                <th>姓名</th>
                <th>职业一</th>
                <th>职业二</th>
                <th>职业三</th>
                <th>起始价</th>
                <th>自我介绍</th>
                <th>操作</th>
            </tr>
        </table>
    </form>
</div>
</body>
</html>
