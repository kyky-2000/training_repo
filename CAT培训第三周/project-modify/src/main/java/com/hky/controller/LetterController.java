package com.hky.controller;

import com.hky.pojo.Letter;
import com.hky.pojo.ResultInfo;
import com.hky.service.LetterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("letter")
public class LetterController {
    @Autowired
    LetterService letterService;

    @RequestMapping("showLetter")
    public @ResponseBody ResultInfo<List<Letter>> showLetter(String addressee){
        return letterService.showLetter(addressee);
    }

    @RequestMapping("reply")
    public @ResponseBody ResultInfo<String> reply(Letter letter){
        return letterService.reply(letter);
    }
}
