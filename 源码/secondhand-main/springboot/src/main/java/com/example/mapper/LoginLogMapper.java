package com.example.mapper;

import cn.hutool.core.lang.Dict;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import com.example.entity.LoginLog;

public interface LoginLogMapper {

    @Select("SELECT DATE(login_time) AS name, COUNT(DISTINCT user_id) AS value " +
            "FROM login_log " +
            "WHERE login_time >= DATE_SUB(CURDATE(), INTERVAL 8 DAY) " +
            "GROUP BY DATE(login_time) " +
            "ORDER BY name ASC")
    List<Dict> selectOnlineTrend();

    int insert(LoginLog log);
}
