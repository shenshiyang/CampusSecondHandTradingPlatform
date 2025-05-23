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
import java.time.LocalDate;

@Service
public class LoginLogService {

    @Resource
    private LoginLogMapper loginLogMapper;

    /**
     * 获取近8日用户在线趋势（包含 0 值日期）
     */
    public List<Dict> getOnlineTrend(String startDate, String endDate) {
        List<Dict> original = loginLogMapper.selectOnlineTrend();
        // 生成区间内所有日期
        List<String> dateList = new ArrayList<>();
        if (startDate != null && endDate != null) {
            DateTime start = DateUtil.parseDate(startDate);
            DateTime end = DateUtil.parseDate(endDate);
            List<DateTime> dateTimes = DateUtil.rangeToList(start, end, DateField.DAY_OF_YEAR);
            dateList = dateTimes.stream().map(DateUtil::formatDate).collect(Collectors.toList());
        } else {
            Date date = new Date();
            DateTime start = DateUtil.offsetDay(date, -8);
            DateTime end = DateUtil.offsetDay(date, -1);
            List<DateTime> dateTimes = DateUtil.rangeToList(start, end, DateField.DAY_OF_YEAR);
            dateList = dateTimes.stream().map(DateUtil::formatDate).sorted().collect(Collectors.toList());
        }
        Map<String, Integer> originalMap = original.stream()
                .collect(Collectors.toMap(d -> d.getStr("name"), d -> d.getInt("value")));
        List<Dict> filledData = new ArrayList<>();
        for (String day : dateList) {
            Integer value = originalMap.getOrDefault(day, 0);
            filledData.add(Dict.create().set("name", day).set("value", value));
        }
        return filledData;
    }

    public List<Dict> getOnlineTrend() {
        return getOnlineTrend(null, null);
    }

    public int insert(LoginLog log) {
        return loginLogMapper.insert(log);
    }

    public List<Dict> getOnlineTrendByType(String dateType) {
        if ("month".equals(dateType)) {
            // 近12个月
            List<Dict> original = loginLogMapper.selectOnlineTrend();
            LocalDate now = LocalDate.now();
            List<String> monthList = new ArrayList<>();
            for (int i = 11; i >= 0; i--) {
                LocalDate month = now.minusMonths(i);
                String ym = month.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM"));
                monthList.add(ym);
            }
            Map<String, Integer> originalMap = original.stream()
                .collect(Collectors.toMap(d -> d.getStr("name").substring(0,7), d -> d.getInt("value"), Integer::sum));
            List<Dict> filledData = new ArrayList<>();
            for (String ym : monthList) {
                Integer value = originalMap.getOrDefault(ym, 0);
                filledData.add(Dict.create().set("name", ym).set("value", value));
            }
            return filledData;
        }
        if ("year".equals(dateType)) {
            // 近5年
            List<Dict> original = loginLogMapper.selectOnlineTrend();
            int currentYear = LocalDate.now().getYear();
            List<String> yearList = new ArrayList<>();
            for (int i = 4; i >= 0; i--) {
                yearList.add(String.valueOf(currentYear - i));
            }
            Map<String, Integer> originalMap = original.stream()
                .collect(Collectors.toMap(d -> d.getStr("name").substring(0,4), d -> d.getInt("value"), Integer::sum));
            List<Dict> filledData = new ArrayList<>();
            for (String y : yearList) {
                Integer value = originalMap.getOrDefault(y, 0);
                filledData.add(Dict.create().set("name", y).set("value", value));
            }
            return filledData;
        }
        // 默认按周（原有逻辑）
        return getOnlineTrend();
    }
}
