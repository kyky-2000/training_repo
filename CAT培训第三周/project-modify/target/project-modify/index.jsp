<%--
  Created by IntelliJ IDEA.
  User: allfather
  Date: 2020/7/27
  Time: 15:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>主页</title>

    <script src="js/jquery-3.3.1.min.js"></script>
    <script>
        function testAjax() {
            var checkCode = "123";
            var data = {"checkCode":checkCode,"mail": "scvc", "password": "csc"};
            $.ajax({
                url: "user/testAjax",
                data: data,
                type: "post",
                dataType: "json",
                success: function(data) {
                    alert(data.code);
                    alert(data.msg);
                }
            });
        }
        function testAjax1() {
            var id = 1;
            var data = {"id": id};
            $.ajax({
                url: "user/selectUserWithHistory",
                data: data,
                type: "post",
                dataType: "json",
                success: function(data) {
                    alert(data.code);
                    alert(data.msg);
                }
            });
        }
        function testSelectInfo(){
            var currentPage = 2;
            var size = 9;
            var data = {"currentPage": currentPage, "size": size};
            $.ajax({
                url: "info/showInfo",
                data: data,
                type: "post",
                dataType: "json",
                success: function(data) {
                    alert(data.code);
                    alert(data.msg);
                }
            });
        }
        function testAjax2() {
            var id = 1;
            var data = {"id": id};
            $.ajax({
                url: "user/selectDetails",
                data: data,
                type: "post",
                dataType: "json",
                success: function(data) {
                    alert(data.code);
                    alert(data.msg);
                    alert(data.data.pictures[2])
                }
            });
        }
        function testPicture() {
            $.ajax({
                url: "user/testPicture",
                type: "post",
                dataType: "json",
                success: function(data) {
                    alert(data.msg);
                    $("#photo").attr("src", "images/info-images/userImages/"+data.data+"");
                }
            });
        }
    </script>
</head>
<body>
<a href="user/testAjax?name=hehe&password=123">测试</a>
<a href="user/select">测试</a>
<a href="login.jsp">转到登录页面</a>
<input type="button" onclick="testAjax();" value="试试ajax跳转页面">
<input type="button" onclick="testAjax1();" value="查一下用户全信息">
<input type="button" onclick="testAjax2();" value="查一下用户信息和高光时刻">
<input type="button" onclick="testSelectInfo();" value="查询一下订单信息"><hr><hr>
<input type="button" onclick="testPicture();" value="展示图片">
<img id="photo">
</body>
</html>
