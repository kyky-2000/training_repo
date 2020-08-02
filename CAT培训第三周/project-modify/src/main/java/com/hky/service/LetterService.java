package com.hky.service;

import com.hky.pojo.Letter;
import com.hky.pojo.ResultInfo;

import java.util.List;

public interface LetterService {

    ResultInfo<List<Letter>> showLetter(String addressee);

    ResultInfo<String> reply(Letter letter);
}
