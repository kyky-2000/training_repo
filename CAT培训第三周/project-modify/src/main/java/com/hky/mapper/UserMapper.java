package com.hky.mapper;

import com.hky.pojo.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserMapper {
    /**
     * 用户登录验证
     * @param user
     * @return
     */
    User login(User user);

    /**
     * 用户注册
     * @param user
     * @return
     */
    int register(User user);

    /**
     * 根据id查询用户
     * @param id
     * @return
     */
    User selectByPrimaryKey(Integer id);

    /**
     * 更新用户信息
     * @param record
     * @return
     */
    int updateByIdSelective(User record);

    /**
     * 查询邮箱是否被注册过
     * @param mail
     * @return
     */
    User selectUserByMail(@Param("mail") String mail);

    /**
     * 查询用户个人信息及转会历史
     * @param id
     * @return
     */
    User selectUserWithHistory(@Param("id") int id);

    /**
     * 查询个人信息及高光时刻
     * @param id
     * @return
     */
    User selectDetails(@Param("id") int id);


    int deleteByPrimaryKey(Integer id);


    int insertSelective(User record);

    int updateByPrimaryKey(User record);
}