package com.example.controller;

import com.example.common.Result;
import com.google.code.kaptcha.Producer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.Base64;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@RestController
public class CaptchaController {

    @Autowired
    private Producer captchaProducer;

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @GetMapping("/api/captcha")
    public Result getCaptcha(HttpServletResponse response) throws Exception {
        // 生成验证码文本
        String code = captchaProducer.createText();
        // 生成唯一标识
        String uuid = UUID.randomUUID().toString();
        // 生成图片
        BufferedImage image = captchaProducer.createImage(code);

        // 存入Redis，5分钟有效
        stringRedisTemplate.opsForValue().set("captcha:" + uuid, code, 5, TimeUnit.MINUTES);

        // 转为Base64
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, "png", baos);
        String base64Img = "data:image/png;base64," + Base64.getEncoder().encodeToString(baos.toByteArray());

        // 返回图片和uuid
        return Result.success(new CaptchaVO(base64Img, uuid));
    }

    // 内部类用于返回前端
    public static class CaptchaVO {
        public String img;
        public String uuid;
        public CaptchaVO(String img, String uuid) {
            this.img = img;
            this.uuid = uuid;
        }
    }
} 