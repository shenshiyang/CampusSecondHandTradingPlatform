package com.example.controller;

import com.example.common.Result;
import com.example.common.enums.ResultCodeEnum;
import com.alibaba.fastjson.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/aiChat")
public class AIChatController {

    @Value("${ai.service.url}")
    private String aiServiceUrl;

    @Value("${ai.service.api-key}")
    private String apiKey;

    @PostMapping("/chat")
    public Result chat(@RequestBody Map<String, Object> request) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + apiKey);
            headers.set("Accept", "application/json");
            headers.set("Accept-Language", "zh-CN");

            // 修改请求消息，添加中文简体要求
            String userMessage = request.get("message").toString();
            if (!userMessage.startsWith("请用中文回答")) {
                userMessage = "请用中文回答以下问题：" + userMessage;
            }
            
            Map<String, Object> body = new HashMap<>();
            body.put("message", userMessage);
            body.put("mode", "chat");
            body.put("userId", request.get("userId"));

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(aiServiceUrl, entity, String.class);

            // 解析JSON响应
            JSONObject jsonObject = JSONObject.parseObject(response.getBody());
            String aiAnswer = jsonObject.getString("textResponse");
            
            // 移除<think>和</think>标签
            aiAnswer = aiAnswer.replace("<think>", "").replace("</think>", "");

            // 返回结果
            Map<String, String> result = new HashMap<>();
            result.put("response", aiAnswer);
            return Result.success(result);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error(ResultCodeEnum.SYSTEM_ERROR.code, "AI服务暂时不可用，请稍后再试");
        }
    }
} 