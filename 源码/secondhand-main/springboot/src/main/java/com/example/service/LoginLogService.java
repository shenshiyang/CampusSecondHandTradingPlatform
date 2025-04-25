package com.example.service;

import cn.hutool.core.date.DateField;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.lang.Dict;
import com.example.entity.LoginLog;
import com.example.mapper.LoginLogMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class LoginLogService {

    @Resource
    private LoginLogMapper loginLogMapper;

    /**
     * 获取近8日用户在线趋势（包含 0 值日期）
     */
    public List<Dict> getOnlineTrend() {
        List<Dict> original = loginLogMapper.selectOnlineTrend();

        // 生成最近8天（不含今天）的日期列表
        Date date = new Date();
        DateTime start = DateUtil.offsetDay(date, -8);
        DateTime end = DateUtil.offsetDay(date, -1);
        List<DateTime> dateTimes = DateUtil.rangeToList(start, end, DateField.DAY_OF_YEAR);
        List<String> dateList = dateTimes.stream()
                .map(DateUtil::formatDate)
                .sorted()
                .collect(Collectors.toList());

        // 转为 map：{ 日期 -> 数量 }
        Map<String, Integer> originalMap = original.stream()
                .collect(Collectors.toMap(d -> d.getStr("name"), d -> d.getInt("value")));

        // 构造补全后的数据
        List<Dict> filledData = new ArrayList<>();
        for (String day : dateList) {
            Integer value = originalMap.getOrDefault(day, 0);
            filledData.add(Dict.create().set("name", day).set("value", value));
        }

        return filledData;
    }

    public int insert(LoginLog log) {
        return loginLogMapper.insert(log);
    }
}
