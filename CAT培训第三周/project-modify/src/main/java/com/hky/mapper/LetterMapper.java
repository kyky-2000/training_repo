package com.hky.mapper;

import com.hky.pojo.Letter;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LetterMapper {
    List<Letter> showLetters(@Param("addressee") String addressee);

    int reply(Letter letter);
}
