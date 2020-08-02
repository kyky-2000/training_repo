package com.hky.mapper;

import com.hky.pojo.Letter;
import com.hky.pojo.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

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
     * 根据转会信息的id查询用户id
     * @param id
     * @return
     */
    int selectUserIdByInfoId(int id);

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
     * 查询用户信息（包括转会历史）
     * @param id
     * @return
     */
    User selectUserWithHistory(@Param("id") int id);

    /**
     *查询高光时刻
     * @param id
     * @return
     */
    List<String> selectHighlight(@Param("id") int id);

    /**
     * 查询用户收到的私信
     * @param id
     * @return
     */
    List<Letter> showLetters(@Param("id") int id);

    /**
     * 回复私信
     * @param letter
     * @return
     */
    int reply(Letter letter);


    int deleteByPrimaryKey(Integer id);


    int insertSelective(User record);

    int updateByPrimaryKey(User record);
}