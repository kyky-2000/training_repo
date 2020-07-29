package com.hky.service;

import com.hky.pojo.ResultInfo;
import com.hky.pojo.User;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestMapping;

public interface UserService {

    ResultInfo<User> login(User user);

    ResultInfo<User> register(User user);

    ResultInfo<User> updateUser(User user);

    ResultInfo<User> selectUserByMail(String mail);

    ResultInfo<User> selectUserWithHistory(int id);

    ResultInfo<User> selectDetails(int id);
}
