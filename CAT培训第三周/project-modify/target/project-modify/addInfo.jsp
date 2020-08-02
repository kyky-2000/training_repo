<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- HTML5文档-->
<!DOCTYPE html>
<!-- 网页使用的语言 -->
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>申请转会</title>

    <!-- 1. 导入CSS的全局样式 -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. 监听输入是否为空 -->
    <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700" rel="stylesheet">
    <!-- 3. jQuery导入，建议使用1.9以上的版本 -->
    <script src="js/jquery-3.3.1.min.js"></script>
    <!-- 4. 导入bootstrap的js文件 -->
    <script src="js/bootstrap.min.js"></script>
    <!-- 5. 日期插件-->
    <script src="js/calendar.js" type="text/javascript" language="javascript"></script>

    <script>
        var user;
        var head;
        var photo1;
        var photo2;
        var photo3;
        function addInfo(){

            var name = $("#name").val();
            var photo = head;
            var introduce = $("#introduce").val();
            var gameCareer1 = $("#gameCareer1").val();
            var gameCareer2 = $("#gameCareer2").val();
            var gameCareer3 = $("#gameCareer3").val();
            var team1 = $("#team1").val();
            var date1 = $("#date1").val();
            var team2 = $("#team2").val();
            var date2 = $("#date2").val();
            var team3 = $("#team3").val();
            var date3 = $("#date3").val();
            var salary = $("#salary").val();
            var photo1 = photo1;
            var photo2 = photo2;
            var photo3 = photo3;
            var status = $(".status").val();

            var json = {"name": name, "photo": photo, "introduce": introduce, "gameCareer1": gameCareer1, "gameCareer2": gameCareer2,
                "gameCareer3": gameCareer3, "team1": team1, "date1": date1, "team2": team2, "date2": date2, "team3": team3, "date3": date3,
                "salary": salary+"", "photo1": photo1, "photo2":photo2, "photo3": photo3, "status": status};

            $.ajax({
                url: "baseServlet/info/addInfo",
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
        function turnHome(){
            window.location.href = "/home.jsp";
        }

        function uploadHighlight() {
            var formData = new FormData($("#highlightForm")[0]);//构造FormData对象

            $.ajax({
                url: 'file/uploadHighlight',//接受请求的Servlet地址
                type: 'POST',
                data: formData,
                processData:false,
                cache: false,//不缓存页面
                async: true,
                contentType: false,//当form以multipart/form-data方式上传文件时，需要设置为false
                dataType:"json",
                success: function (data) {
                    alert(data.msg);
                    var list = data.data;
                    var len = list.length;
                    switch (len) {
                        case 0:
                            break;
                        case 3:
                            photo3 = list[2];
                        case 2:
                            photo2 = list[1];
                        case 1:
                            photo1 = list[0];
                    }
                },
                error: function () {
                    alert("服务器繁忙，请稍后重试");
                }

            });
        }
        function uploadPhoto() {
            var formData = new FormData($("#photoForm")[0]);
            $.ajax({
                url: 'file/uploadPhoto',//接受请求的Servlet地址
                type: 'POST',
                data: formData,
                processData:false,
                cache: false,//不缓存页面
                async: true,
                contentType: false,//当form以multipart/form-data方式上传文件时，需要设置为false
                dataType:"json",
                success: function (data) {
                    alert(data.data + "上传成功");
                    head = data.data;
                },
                error: function () {
                    alert("服务器繁忙，请稍后重试");
                }
            });
        }
    </script>
</head>
<body>
<div class="container">
    <div style="text-align: center;"><h3>申请转会</h3></div>
    <form method="post">
        <div class="form-group">
            <form id="photoForm" enctype="multipart/form-data">
                <label>靓仔，传张照片吧，听说颜值高的人比较抢手哦</label>
                <input type="file" name="upload"/>
                <input type="button" value="上传" onclick="uploadPhoto()">
            </form>
        </div>
        <div class="form-group">
            <label for="name">姓名：</label>
            <input type="text" class="form-control" id="name" name="name" >
        </div>
        <div class="form-group">
            <label for="introduce">自我介绍：</label>
            <input type="text" class="form-control" id="introduce" name="introduce">
        </div>

        <div class="form-group">
            <label for="gameCareer1">擅长职业1：</label>
            <input type="text" class="form-control" id="gameCareer1" name="gameCareer1"/>
        </div>
        <div class="form-group">
            <label for="gameCareer2">擅长职业2：</label>
            <input type="text" class="form-control" id="gameCareer2" name="gameCareer2"/>
        </div>
        <div class="form-group">
            <label for="gameCareer3">擅长职业3：</label>
            <input type="text" class="form-control" id="gameCareer3" name="gameCareer3"/>
        </div>
        <div class="form-group">
            <label>转会历史：</label>
            <p>
                <input type="text" calss="form-control" id="team1" name="team1" placeholder="加入的战队">
                <input type="text" class="form-control" id="date1" name="date1" onclick="SetDate(this,'yyyy-MM-dd')"
                       readonly="readonly" placeholder="加入的时间"/>
            </p>
            <p>
                <input type="text" calss="form-control" id="team2" name="team1" placeholder="加入的战队">
                <input type="text" class="form-control" id="date2" name="date1" onclick="SetDate(this,'yyyy-MM-dd')"
                       readonly="readonly" placeholder="加入的时间"/>
            </p>
            <p>
                <input type="text" calss="form-control" id="team3" name="team1" placeholder="加入的战队">
                <input type="text" class="form-control" id="date3" name="date1" onclick="SetDate(this,'yyyy-MM-dd')"
                       readonly="readonly" placeholder="加入的时间"/>
            </p>
        </div>

        <div class="form-group">
            <label for="salary">预想薪水：</label>
            <input type="text" class="form-control" id="salary" name="salary" />
        </div>
        <div class="form-group">
            <form id="highlightForm" enctype="multipart/form-data">
                <label>可上传几张高光图片展示一下实力</label>
                <input type="file" name="upload" id="file"/>
                <input type="file" name="upload" id="file1"/>
                <input type="file" name="upload" id="file2"/>
                <input type="button" value="上传" onclick="uploadHighlight()">
            </form>
        </div>
        <div class="form-group">
            <label>展示模式</label>
            <input type="radio" name="status" class="status" value="正常" checked="checked"/>正常
            <input type="radio" name="status" class="status" value="拍卖"/>拍卖
        </div>
        <div class="form-group" style="text-align: center">
            <input class="btn btn-primary" type="submit" value="提交" onclick="addInfo();"/>
            <a ><input class="btn btn-default" type="button" value="返回" onclick="turnHome()"/></a>
        </div>
    </form>
</div>
</body>
</html>
