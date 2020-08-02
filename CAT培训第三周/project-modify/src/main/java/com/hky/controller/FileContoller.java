package com.hky.controller;

import com.hky.pojo.ResultInfo;
import org.springframework.jdbc.core.ResultSetSupportingSqlParameter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("file")
public class FileContoller {
    @RequestMapping("uploadHead")
    public @ResponseBody ResultInfo<String> fileUpload(MultipartFile upload) throws Exception {
        //文件上传位置
        String path = "D:\\servlet\\project-modify\\src\\main\\webapp\\theme\\images";
        System.out.println(path);
        //判断文件路径是否存在，不存在则新建
        File file = new File(path);
        if(!file.exists()){
            file.mkdirs();
        }

        //获取上传文件项的名字
        String itemName = upload.getOriginalFilename();
        //生成唯一文件名，防止同名覆盖(将随机码里的 - 去掉，可能是因为文件名称不能含这个吧)
        String uuid =  UUID.randomUUID().toString().replace("-", "");
        itemName = uuid + "_" + itemName;
        //完成文件上传
        upload.transferTo(new File(path, itemName));

        return new ResultInfo<String>(200, "上传成功", itemName);
    }

    @RequestMapping("uploadPhoto")
    public @ResponseBody ResultInfo<String> uploadPhoto(MultipartFile upload) throws Exception {
        //文件上传位置
        String path = "D:\\servlet\\project-modify\\src\\main\\webapp\\theme\\images\\info-images";
        //判断文件路径是否存在，不存在则新建
        File file = new File(path);
        if(!file.exists()){
            file.mkdirs();
        }

        System.out.println(upload);
        //获取上传文件项的名字
        String itemName = upload.getOriginalFilename();
        //生成唯一文件名，防止同名覆盖(将随机码里的 - 去掉，可能是因为文件名称不能含这个吧)
        String uuid =  UUID.randomUUID().toString().replace("-", "");
        itemName = uuid + "_" + itemName;
        //完成文件上传
        upload.transferTo(new File(path, itemName));

        return new ResultInfo<String>(200, "上传成功", itemName);
    }

    @RequestMapping("uploadHighlight")
    public @ResponseBody ResultInfo<List<String>> uploadHighlight(MultipartFile[] upload) throws Exception {
        //文件上传位置
        String path = "D:\\servlet\\project-modify\\src\\main\\webapp\\theme\\images\\info-images\\highlight";
        System.out.println(path);
        //判断文件路径是否存在，不存在则新建
        File file = new File(path);
        if(!file.exists()){
            file.mkdirs();
        }

        List<String> pictures = new ArrayList<>();

        for(MultipartFile multipartFile : upload){
            //获取上传文件项的名字
            String itemName = multipartFile.getOriginalFilename();
            //生成唯一文件名，防止同名覆盖(将随机码里的 - 去掉，可能是因为文件名称不能含这个吧)
            String uuid =  UUID.randomUUID().toString().replace("-", "");
            itemName = uuid + "_" + itemName;
            //完成文件上传
            multipartFile.transferTo(new File(path, itemName));
            pictures.add(itemName);
        }

        return new ResultInfo<List<String>>(200, "上传成功", pictures);
    }
}
