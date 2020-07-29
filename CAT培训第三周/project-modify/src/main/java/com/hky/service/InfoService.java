package com.hky.service;

import com.hky.pojo.PageBean;
import com.hky.pojo.ResultInfo;
import com.hky.pojo.TransferInfo;

import java.util.ArrayList;
import java.util.List;

public interface InfoService {

    /**
     * 查询转会信息到页面展示（包括拍卖场的）
     * @param pageBean
     * @return
     */
    ResultInfo<PageBean<TransferInfo>> showInfo(PageBean<TransferInfo> pageBean);

    /**
     * 查询轮播图的照片
     * @return
     */
    ResultInfo<List<String>> selectRotationPhotos();

    /**
     * 转会申请
     * @param transferInfo
     * @return
     */
    ResultInfo<String> applyForTransfer(TransferInfo transferInfo);

    ResultInfo<String> updateInfo(TransferInfo transferInfo);

    ResultInfo<String> deleteInfo(int id);
}
