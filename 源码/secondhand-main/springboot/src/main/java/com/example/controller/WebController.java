package com.example.controller;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.example.common.Result;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.LoginLog;
import com.example.exception.CustomException;
import com.example.service.AdminService;
import com.example.service.LoginLogService;
import com.example.service.UserService;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.time.LocalDateTime;

/**
 * 基础前端接口
 */
@RestController
public class WebController {

    @Resource
    private AdminService adminService;
    @Resource
    UserService userService;
    @Resource
    private LoginLogService loginLogService;
    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @GetMapping("/")
    public Result hello() {
        return Result.success("访问成功");
    }

    /**
     * 登录
     */
    @PostMapping("/login")
    public Result login(@RequestBody Account account) {
        // 验证码校验
        String captcha = account.getCaptcha();
        String captchaUuid = account.getCaptchaUuid();
        String redisCode = stringRedisTemplate.opsForValue().get("captcha:" + captchaUuid);
        if (redisCode == null || !redisCode.equalsIgnoreCase(captcha)) {
            return Result.error("400", "验证码错误或已过期");
        }
        stringRedisTemplate.delete("captcha:" + captchaUuid);
        if (ObjectUtil.isEmpty(account.getUsername()) || ObjectUtil.isEmpty(account.getPassword())
                || ObjectUtil.isEmpty(account.getRole())) {
            return Result.error(ResultCodeEnum.PARAM_LOST_ERROR);
        }
        if (RoleEnum.ADMIN.name().equals(account.getRole())) {
            account = adminService.login(account);
        } else if (RoleEnum.USER.name().equals(account.getRole())) {
            account = userService.login(account);
        } else {
            throw new CustomException(ResultCodeEnum.PARAM_LOST_ERROR);
        }

        LoginLog log = new LoginLog();
        log.setUserId(account.getId().longValue());
        log.setLoginTime(LocalDateTime.now());
        loginLogService.insert(log);

        return Result.success(account);
    }

    /**
     * 注册
     */
    @PostMapping("/register")
    public Result register(@RequestBody Account account) {
        // 验证码校验
        String captcha = account.getCaptcha();
        String captchaUuid = account.getCaptchaUuid();
        String redisCode = stringRedisTemplate.opsForValue().get("captcha:" + captchaUuid);
        if (redisCode == null || !redisCode.equalsIgnoreCase(captcha)) {
            return Result.error("400", "验证码错误或已过期");
        }
        stringRedisTemplate.delete("captcha:" + captchaUuid);
        if (StrUtil.isBlank(account.getUsername()) || StrUtil.isBlank(account.getPassword())
                || ObjectUtil.isEmpty(account.getRole()) || account.getPassword().length() < 6) {
            return Result.error("400", "密码长度不能少于6位");
        }
        if (RoleEnum.USER.name().equals(account.getRole())) {
            userService.register(account);
        } else {
            throw new CustomException(ResultCodeEnum.PARAM_LOST_ERROR);
        }
        return Result.success();
    }

    /**
     * 修改密码
     */
    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody Account account) {
        if (StrUtil.isBlank(account.getUsername()) || StrUtil.isBlank(account.getPassword())
                || ObjectUtil.isEmpty(account.getNewPassword())) {
            return Result.error(ResultCodeEnum.PARAM_LOST_ERROR);
        }
        if (RoleEnum.ADMIN.name().equals(account.getRole())) {
            adminService.updatePassword(account);
        } else if (RoleEnum.USER.name().equals(account.getRole())) {
            userService.updatePassword(account);
        }
        return Result.success();
    }

}
