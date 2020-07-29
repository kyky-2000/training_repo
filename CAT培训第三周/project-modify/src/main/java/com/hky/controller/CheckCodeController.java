package com.hky.controller;

import com.hky.pojo.ResultInfo;
import com.hky.pojo.User;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

@Controller
@RequestMapping("/checkCode")
public class CheckCodeController {

    @RequestMapping("/getCheckCode")
    public void getCheckCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //服务器通知浏览器不要缓存
        response.setHeader("pragma","no-cache");
        response.setHeader("cache-control","no-cache");
        response.setHeader("expires","0");

        //在内存中创建一个长80，宽30的图片，默认黑色背景
        //参数一：长
        //参数二：宽
        //参数三：颜色
        int width = 80;
        int height = 30;
        BufferedImage image = new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);

        //获取画笔
        Graphics g = image.getGraphics();
        //设置画笔颜色为灰色
        g.setColor(Color.GRAY);
        //填充图片
        g.fillRect(0,0, width,height);

        //产生4个随机验证码，12Ey
        String checkCode = getCheckCode();
        //将验证码放入HttpSession中
        request.getSession().removeAttribute("_checkCode");
        request.getSession().setAttribute("_checkCode",checkCode);

        //设置画笔颜色为黄色
        g.setColor(Color.YELLOW);
        //设置字体的小大
        g.setFont(new Font("黑体",Font.BOLD,24));
        //向图片上写入验证码
        g.drawString(checkCode,15,25);

        //将内存中的图片输出到浏览器
        //参数一：图片对象
        //参数二：图片的格式，如PNG,JPG,GIF
        //参数三：图片输出到哪里去
        ImageIO.write(image,"PNG",response.getOutputStream());
    }
    private String getCheckCode() {
        String base = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        int size = base.length();
        Random r = new Random();
        StringBuffer sb = new StringBuffer();
        for (int i = 1; i <= 4; i++) {
            //产生0到size-1的随机值
            int index = r.nextInt(size);
            //在base字符串中获取下标为index的字符
            char c = base.charAt(index);
            //将c放入到StringBuffer中去
            sb.append(c);
        }
        return sb.toString();
    }

    @RequestMapping("sendMailCode")
    public ResultInfo sendMailCode(User user){
        String mail = user.getMail();
        String code = getCheckCode();

        HtmlEmail email = new HtmlEmail();
        try {
            email.setHostName("smtp.qq.com");
            email.setCharset("utf-8");
            email.addTo(mail);
            email.setFrom("2243592288@qq.com", "2243592288@qq.com");
            email.setAuthentication("2243592288@qq.com", "rcplvkopbaklebcd");
            email.addHeader("X-Mailer","Microsoft Outlook Express 6.00.2900.2869");
            email.setSubject("验证码来啦");
            email.setMsg(code);
            email.send();
            System.out.println("发送成功");
        } catch (EmailException e) {
            e.printStackTrace();
        }

        ResultInfo<String> resultInfo = new ResultInfo();
        resultInfo.setCode(200);
        resultInfo.setMsg("发送成功");
        resultInfo.setData(code);
        return resultInfo;
    }
}
