// $(function() {
//     $(".btnn").click(function () {
//         if (checkEMail($("#loginName")) == true) {
//             $("form").action("/loginServlet");
//         } else {
//             alert("账号非邮箱地址！");
//         }
//     });
//
//     function checkEMail(e){
//         var reEml = /^[\w\-\.]+@[a-z0-9]+(\-[a-z0-9]+)?(\.[a-z0-9]+(\-[a-z0-9]+)?)*\.[a-z]{2,4}$/i;
//         if(reEml.test(e.val())){
//             return true;
//         }else{
//             return false;
//         }
//     }
//
//     // function checkInput(){
//     //     if($("#loginName").val()=="" || $("#loginPwd").val()=="" || $("#loginName").val()==null || $("#loginPwd").val()==null){
//     //         return false;
//     //     }else{
//     //         return true;
//     //     }
//     // }
//
// });