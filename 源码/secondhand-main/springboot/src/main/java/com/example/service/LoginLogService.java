package com.example.service;

import cn.hutool.core.lang.Dict;
import com.example.entity.LoginLog;
import com.example.mapper.LoginLogMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class LoginLogService {

    @Resource
    private LoginLogMapper loginLogMapper;

    public List<Dict> getOnlineTrend() {
        return loginLogMapper.selectOnlineTrend();
    }

    public int insert(LoginLog log) {
        return loginLogMapper.insert(log);
    }
}
