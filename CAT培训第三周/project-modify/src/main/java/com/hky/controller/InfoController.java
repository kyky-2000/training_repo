package com.hky.controller;

import com.hky.pojo.PageBean;
import com.hky.pojo.ResultInfo;
import com.hky.pojo.TransferInfo;
import com.hky.service.InfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@RequestMapping("info")
@Controller
public class InfoController {
    @Autowired
    private InfoService infoService;

    @RequestMapping("showInfo")
    public @ResponseBody ResultInfo<PageBean<TransferInfo>> showInfo(PageBean<TransferInfo> pageBean){
        return infoService.showInfo(pageBean);
    }

    @RequestMapping("selectRotationPhotos")
    public @ResponseBody ResultInfo<List<String>> selectRotationPhotos(){
        return infoService.selectRotationPhotos();
    }

    @RequestMapping("applyForTransfer")
    public @ResponseBody ResultInfo<String> applyForTransfer(TransferInfo transferInfo, HttpServletRequest request){
        HttpSession session = request.getSession();
        String photo = (String)session.getAttribute("photo");
        transferInfo.setPhoto(photo);
        session.removeAttribute("photo");
        return infoService.applyForTransfer(transferInfo);
    }

    @RequestMapping("updateInfo")
    public @ResponseBody ResultInfo<String> updateInfo(TransferInfo transferInfo){
        return infoService.updateInfo(transferInfo);
    }

    @RequestMapping("deleteInfo")
    public @ResponseBody ResultInfo<String> deleteInfo(int id){
        return infoService.deleteInfo(id);
    }
}
