package com.hky.service.impl;

import com.hky.mapper.UserMapper;
import com.hky.pojo.ResultInfo;
import com.hky.pojo.User;
import com.hky.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Date;
import java.util.Random;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public ResultInfo<User> login(User user) {
        user = userMapper.login(user);
        if(user==null || user.getStatus().equals("未通过")){
            return new ResultInfo<>(500, "用户不存在", null);
        }else if(user.getStatus().equals("封禁")){
            return new ResultInfo<>(500, "您已被封禁，请规范行为", null);
        }else{
            return new ResultInfo<User>(200, "登录成功", user);
        }

    }

    @Override
    public ResultInfo<User> register(User user){
        user.setStatus("未通过");
        int result = userMapper.register(user);
        if(1 == result){
            return new ResultInfo<User>(200, "提交成功，请等待管理员审核", null);
        }else{
            return new ResultInfo<User>(500, "系统繁忙，请稍后重试", null);
        }
    }

    @Override
    public ResultInfo<User> updateUser(User user){
        int result = userMapper.updateByIdSelective(user);
        if(1 == result){
            return new ResultInfo<User>(200, "修改成功", null);
        }else{
            return new ResultInfo<User>(500, "系统繁忙，请稍后重试", null);
        }
    }

    @Override
    public ResultInfo<User> selectUserByMail(String mail){
        User user = userMapper.selectUserByMail(mail);
        if(null == user){
            return new ResultInfo<User>(500, "此邮箱已被注册过,你可直接登录", null);
        }else{
            return new ResultInfo<User>(200, "邮箱可使用", null);
        }
    }

    @Override
    public ResultInfo<User> selectUserWithHistory(int id){
        User user =  userMapper.selectUserWithHistory(id);
        System.out.println(user);
        if(null == user){
            return new ResultInfo<User>(500, "用户不存在", null);
        }else{
            return new ResultInfo<User>(200, "查询成功", user);
        }
    }

    @Override
    public ResultInfo<User> selectDetails(int id){
        User user = userMapper.selectDetails(id);
        System.out.println(user);
        if(null == user){
            return new ResultInfo<User>(500, "服务器繁忙", null);
        }else{
            return new ResultInfo<User>(200, "查询成功", user);
        }
    }


}
