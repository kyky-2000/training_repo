package com.hky.mapper;

import com.hky.pojo.PageBean;
import com.hky.pojo.ResultInfo;
import com.hky.pojo.TransferInfo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;

@Repository
public interface InfoMapper {

    /**
     * 查询总记录数
     * @param pageBean
     * @return
     */
    int selectCount(PageBean<TransferInfo> pageBean);

    /**
     * 查询一页的转会信息
     * @param pageBean
     * @return
     */
    ArrayList<TransferInfo> showInfo(PageBean<TransferInfo> pageBean);

    /**
     * 查询轮播图的照片
     * @return
     */
    List<String> selectRotationPhotos();

    /**
     * 提交转会申请
     * @param transferInfo
     * @return
     */
    int applyForTransfer(TransferInfo transferInfo);

    /**
     * 修改转会信息
     * @param transferInfo
     * @return
     */
    int updateInfo(TransferInfo transferInfo);

    /**
     * 管理员删除转会信息
     * @param id
     * @return
     */
    int deleteInfo(@Param("id") int id);


    int deleteByPrimaryKey(Integer id);

    int insert(TransferInfo record);

    int insertSelective(TransferInfo record);

    TransferInfo selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(TransferInfo record);

    int updateByPrimaryKey(TransferInfo record);
}