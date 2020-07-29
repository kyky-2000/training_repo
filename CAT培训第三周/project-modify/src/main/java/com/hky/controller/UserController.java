package com.hky.controller;

import com.hky.pojo.ResultInfo;
import com.hky.pojo.User;
import com.hky.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
    public String testAjax(User user){
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

    @RequestMapping("selectUserWithHistory")
    public @ResponseBody ResultInfo<User> selectUserWithHistory(int id){
        return userService.selectUserWithHistory(id);
    }

    @RequestMapping("selectDetails")
    public @ResponseBody ResultInfo<User> selectDetails(int id){
        return userService.selectDetails(id);
    }

}
