<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>个人主页</title>
    <!-- 1. 导入CSS的全局样式 -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="js/jquery-3.3.1.min.js"></script>
    <!-- 3. 导入bootstrap的js文件 -->
    <script src="js/bootstrap.min.js"></script>
<%--    <script type="text/javascript">--%>
<%--    </script>--%>
    <style type="text/css">
        .mat20{margin-top: 20px;}
        .highlight ul li img{width: 90%;margin: 0 auto;}
    </style>

    <script>
        function searchPersonalInfo() {
            $.ajax({
                url: "user/selectAllUserInfo",
                type: "POST",
                dataType: "json",
                success : function (data) {
                    var user = data.data;
                    var historyList = user.historyList;
                    if(user.head != null){
                        $("#headPicture").attr("src", "images/" + user.head);
                    }
                    $("#uID").html(user.ID);
                    $("#personalData").append("<tr><td>姓名</td><td>"+user.name+"</td></tr>");
                    $("#personalData").append("<tr><td>年龄</td><td>"+user.age+"</td></tr>");
                    $("#personalData").append("<tr><td>性别</td><td>"+user.gender+"</td></tr>");
                    $("#personalData").append("<tr><td>邮箱</td><td>"+user.mail+"</td></tr>");
                    $("#personalData").append("<tr><td>上一支战队</td><td>"+(user.lastTeam!=null?user.lastTeam:"")+"</td></tr>");
                    $("#personalData").append("<tr><td>加入LPL时间</td><td>"+(user.joinDate!=null?user.joinDate:"")+"</td></tr>");
                    $("#personalData").append("<tr><td>个人简介</td><td>"+user.profile+"</td></tr>");
                    for(var i=0; i<historyList.length; ++i){
                        $("#personalData").append("<tr><td>加入"+historyList[i].team+"</td><td>"+historyList[i].date+"</td></tr>");
                    }

                    var letters = user.letters;
                    for(var j=0; j<letters; ++j){
                        $("#letter").append("<tr><td>"+letters[j].sender+"</td><td>"+letters[j].content+"</td><td><button onclick=\"reply('"+letters[j].sender+"')\">回复</button></td></tr>")
                    }
                },
                error:function () {
                    alert("服务器繁忙");
                }
            })
        }
        function turnHome(){
            window.location.href = "/home.jsp";
        }
        function reply(addressee) {
            var content = prompt("请输入您要回复的内容：");
            if(content==null || content==""){
                alert("请输入您要回复的内容");
                return;
            }
            $.ajax({
                url: "user/reply",
                data: {"addressee": addressee, "content": content},
                dataType: "json",
                type: "POST",
                success: function (data) {
                    alert("回复成功");
                },
                error:function () {
                    alert("服务器繁忙");
                }

            })
        }

    </script>

</head>
<body onload="searchPersonalInfo()">
<input type="hidden" name="id">
<div align="center">
    <img id="headPicture" src="theme/images/uzi.jpg" alt="..." class="img-circle"/>
</div>
<form class="form-horizontal" style="margin-left: 480px; width: 600px; font-size: 21px;">
    <hr>
    <table class="table table-striped" id="personalData" style="font-size: 22px">
        <tr>
            <th>类型</th>
            <th>内容</th>
        </tr>
    </table>
</form>
<a href="${pageContext.request.contextPath}/updateServlet"><button type="button" class="btn btn-info" style="margin-left: 800px">修改信息</button></a>
<a ><input class="btn btn-default" type="button" value="返回" onclick="turnHome()" /></a>
<hr>

<div style="margin-left: 350px; width: 900px;" id="letterPage">
    <div class="page-header" style="margin:0 auto;">
        <h2>私信</h2>
    </div>
    <table id="letter" class="table table-hover" >
        <tr>
            <th>发信人</th>
            <th>内容</th>
            <th>操作</th>
        </tr>
    </table>

</div>
</body>
</html>
