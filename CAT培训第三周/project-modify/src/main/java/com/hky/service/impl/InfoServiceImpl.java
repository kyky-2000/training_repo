package com.hky.service.impl;

import com.hky.mapper.InfoMapper;
import com.hky.pojo.PageBean;
import com.hky.pojo.ResultInfo;
import com.hky.pojo.TransferInfo;
import com.hky.service.InfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class InfoServiceImpl implements InfoService {
    @Autowired
    private InfoMapper infoMapper;

    @Override
    public ResultInfo<PageBean<TransferInfo>> showInfo(PageBean<TransferInfo> pageBean) {
        if(pageBean.getStatus().equals("正常")){
            return showAuctionInfo(pageBean);
        }

        int currentPage = pageBean.getCurrentPage();
        int size = pageBean.getSize();
        if(currentPage <= 0 ){
            pageBean.setCurrentPage(currentPage=1);
        }
        if(size <= 0){
            pageBean.setSize(size=9);
        }
        pageBean.setStartIndex((currentPage-1) * size);
        pageBean.setStatus("正常");

        int totalCount = infoMapper.selectCount(pageBean);
        pageBean.setTotalCount(totalCount);
        int totalPage = (totalCount % size)==0 ? (totalCount / size) : (totalCount / size)+1;
        pageBean.setTotalPage(totalPage);

        ArrayList<TransferInfo> infoList =  infoMapper.showInfo(pageBean);
        pageBean.setDataList(infoList);

        return new ResultInfo<PageBean<TransferInfo>>(200, "查询成功", pageBean);
    }

    public ResultInfo<PageBean<TransferInfo>> showAuctionInfo(PageBean<TransferInfo> pageBean){
        List<TransferInfo> list = infoMapper.showInfo(pageBean);
        Date date = new Date();

        for(TransferInfo transferInfo : list){
            if(-1 == transferInfo.getDeadline().compareTo(date)){
                list.remove(transferInfo);
            }
        }
        pageBean.setDataList(list);
        return new ResultInfo<PageBean<TransferInfo>>(200, "查询成功", pageBean);
    }

    @Override
    public ResultInfo<List<String>> selectRotationPhotos(){
        List<String> photoList = infoMapper.selectRotationPhotos();
        return new ResultInfo<List<String>>(200, "查询成功", photoList);
    }

    @Override
    public ResultInfo<String> applyForTransfer(TransferInfo transferInfo){
        if(transferInfo.getStatus().equals("申请拍卖")){
            transferInfo.setDeadline(new Date());
        }
        transferInfo.setStatus("未通过");
        int result = infoMapper.applyForTransfer(transferInfo);
        if(1 == result){
            return new ResultInfo<String>(200, "提交成功，请等待管理员审核", null);
        }else{
            return new ResultInfo<String>(500, "服务器繁忙", null);
        }
    }

    @Override
    public ResultInfo<String> updateInfo(TransferInfo transferInfo){
        if(null == transferInfo.getStatus()){
            transferInfo.setDeadline(new Date());
        }
        int result = infoMapper.updateInfo(transferInfo);
        ResultInfo<String> resultInfo = new ResultInfo<String>();
        if(1 == result){
            resultInfo.setCode(200);
            if(null != transferInfo.getStatus()){
                resultInfo.setMsg("举报成功");
            }else{
                resultInfo.setMsg("竞拍成功");
            }
        }else{
            resultInfo.setCode(500);
            resultInfo.setMsg("系统繁忙，请稍后重试");
        }
        return resultInfo;
    }

    @Override
    public ResultInfo<String> deleteInfo(int id){
        int result = infoMapper.deleteInfo(id);
        if(1 == result){
            return new ResultInfo<String>(200, "撤销信息成功", null);
        }else{
            return new ResultInfo<String>(500, "服务器繁忙", null);
        }
    }

}
