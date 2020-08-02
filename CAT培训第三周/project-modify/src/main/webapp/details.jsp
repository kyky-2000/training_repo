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
        var json = $.parseJSON(sessionStorage.getItem("json"));

        function searchPersonalInfo() {

            $.ajax({
                url: "user/selectDetails",
                type: "POST",
                data: {"id": json.id},
                dataType: "json",
                success : function (data) {
                    var user = data.data;
                    var historyList = user.historyList;
                    var pictures = user.pictures;
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

                    $("#buttons").append("<input class=\"btn btn-default\" type=\"button\" value=\"私信\" id=\"sendLetter\" onclick=\"sendLetter('"+user.name+"')\" />")

                    var picture;
                    for(var j=0; j<pictures.length; ++j)
                        picture = pictures[j];
                        $("#highlight").append("<li class=\"col-md-4 col-sm-4 col-xs-4 mat20\"><img src=\"images/info-images/highlight/"+picture+"\"></li>");
                },
                error:function () {
                    alert("服务器繁忙");
                }
            })
        }
        function turnHome(){
            window.location.href = "/home.jsp";
        }
        function sendLetter(addressee) {
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
                    alert("私信成功");
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
    <img id="headPicture" src="images/uzi.jpg" alt="..." class="img-circle"/>
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
<div id="buttons">
<input class="btn btn-default" type="button" value="返回" onclick="turnHome()" />
</div>
<hr>
<div>
    <div class="highlight">
        <div class="page-header" style="margin:0 auto;">
            <h2>高光时刻 <small>秀起来</small></h2>
        </div>
        <ul id="highlight">
        </ul>
    </div>
</div>
</body>
</html>
