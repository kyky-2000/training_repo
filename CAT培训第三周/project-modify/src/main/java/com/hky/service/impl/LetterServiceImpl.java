package com.hky.service.impl;

import com.hky.mapper.LetterMapper;
import com.hky.pojo.Letter;
import com.hky.pojo.ResultInfo;
import com.hky.service.LetterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LetterServiceImpl implements LetterService {
    @Autowired
    LetterMapper letterMapper;

    @Override
    public ResultInfo<List<Letter>> showLetter(String addressee){
        List<Letter> letterList = letterMapper.showLetters(addressee);
        return new ResultInfo<>(200, "评论查询成功", letterList);
    }

    @Override
    public ResultInfo<String> reply(Letter letter){
        int result = letterMapper.reply(letter);
        if(1 == result){
            return new ResultInfo<>(200, "回复成功", null);
        }else{
            return new ResultInfo<>(500, "系统繁忙", null);
        }
    }
}
