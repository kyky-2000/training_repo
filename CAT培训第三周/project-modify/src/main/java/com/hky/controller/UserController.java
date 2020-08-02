package com.hky.controller;

import com.hky.pojo.Letter;
import com.hky.pojo.ResultInfo;
import com.hky.pojo.User;
import com.hky.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/testAjax")
    public String testAjax(@RequestBody User user){
        System.out.println(user);
        System.out.println("执行完事了，我要跳转啦");
        return "success";
    }

//    @RequestMapping("/select")
//    public ModelAndView testSelect(ModelAndView modelAndView){
//        User user = userService.selectById(1);
//        modelAndView.addObject("user", user);
//        modelAndView.setViewName("success");
//        return modelAndView;
//    }

    @RequestMapping("/testPicture")
    public @ResponseBody ResultInfo<String> testPicture(){
        System.out.println("图片给你了");
        return new ResultInfo<>(200, "展示图片了", "1.jpg");
    }

    @RequestMapping("/login")
    public @ResponseBody ResultInfo<User> login(User user, HttpServletRequest request){

        HttpSession session = request.getSession();
        String _checkCode = (String) session.getAttribute("_checkCode");
        session.removeAttribute("_checkCode");

        if(!_checkCode.equalsIgnoreCase(user.getCheckCode())){
            System.out.println(_checkCode + "和"+ user.getCheckCode() + "不一样");
            return new ResultInfo<User>(500, "验证码错误", null);
        }
        ResultInfo<User> resultInfo = userService.login(user);
        if(null != resultInfo.getData()){
            request.getSession().setAttribute("user", resultInfo.getData());
        }
        return resultInfo;
    }

    @RequestMapping("/getUser")
    public @ResponseBody User getUser(ModelMap modelMap){
        User user = (User)modelMap.get("user");
        user = new User(1, "小李子", 25, "男", "753@qq.com", "123456", "RNG", "职业选手", null, "来了来了", "1.jpg", "正常");
        return user;
    }

    @RequestMapping("/register")
    public @ResponseBody ResultInfo register(User user, HttpServletRequest request){

        HttpSession session = request.getSession();
        String _emailCode = (String) session.getAttribute("_emailCode");
        String head = (String)session.getAttribute("head");
        user.setHead(head);
        session.removeAttribute("head");

        if(!_emailCode.equalsIgnoreCase(user.getEmailCode())){
            return new ResultInfo(500, "验证码错误", null);
        }
        session.removeAttribute("head");

        return userService.register(user);
    }

    @RequestMapping("updateUser")
    public @ResponseBody ResultInfo updateUesr(User user){
        return userService.updateUser(user);
    }

    @RequestMapping("selectUserByMail")
    public @ResponseBody ResultInfo findUserByMail(String mail){
        return userService.selectUserByMail(mail);
    }

    @RequestMapping("selectAllUserInfo")
    public @ResponseBody ResultInfo<User> selectAllUserInfo(HttpServletRequest request){
        User user = (User)request.getSession().getAttribute("user");
        return userService.selectAllUserInfo(user.getId());
    }

    @RequestMapping("selectDetails")
    public @ResponseBody ResultInfo<User> selectDetails(Integer id){
        System.out.println(id);
        return userService.selectDetails(id);
    }

    @RequestMapping("reply")
    public @ResponseBody ResultInfo<String> reply(Letter letter, HttpServletRequest request){
        User user = (User)request.getSession().getAttribute("user");
        letter.setSender(user.getName());
        return userService.reply(letter);
    }

}
