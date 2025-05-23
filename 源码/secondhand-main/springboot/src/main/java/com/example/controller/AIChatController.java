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
import com.example.entity.AIChatHistory;
import com.example.mapper.AIChatHistoryMapper;
import org.springframework.beans.factory.annotation.Autowired;

@RestController
@RequestMapping("/aiChat")
public class AIChatController {

    @Value("${ai.service.url}")
    private String aiServiceUrl;

    @Value("${ai.service.api-key}")
    private String apiKey;

    @Autowired
    private AIChatHistoryMapper aiChatHistoryMapper;

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
            Long userId = Long.valueOf(request.get("userId").toString());

            // 保存用户消息
            AIChatHistory userMsg = new AIChatHistory();
            userMsg.setUserId(userId);
            userMsg.setSender("user");
            userMsg.setContent(request.get("message").toString());
            aiChatHistoryMapper.insert(userMsg);

            Map<String, Object> body = new HashMap<>();
            body.put("message", userMessage);
            body.put("mode", "chat");
            body.put("userId", request.get("userId"));

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(aiServiceUrl, entity, String.class);

            // 解析JSON响应
            JSONObject jsonObject = JSONObject.parseObject(response.getBody());
            String aiAnswer = jsonObject.getString("textResponse");
            
            // 移除<think>和</think>标签及其内容
            aiAnswer = aiAnswer.replaceAll("<think>[\\s\\S]*?</think>", "");

            // 保存AI回复
            AIChatHistory aiMsg = new AIChatHistory();
            aiMsg.setUserId(userId);
            aiMsg.setSender("ai");
            aiMsg.setContent(aiAnswer);
            aiChatHistoryMapper.insert(aiMsg);

            // 返回结果
            Map<String, String> result = new HashMap<>();
            result.put("response", aiAnswer);
            return Result.success(result);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error(ResultCodeEnum.SYSTEM_ERROR.code, "AI服务暂时不可用，请稍后再试");
        }
    }

    /**
     * 查询历史聊天记录
     */
    @GetMapping("/history")
    public Result getHistory(@RequestParam Long userId,
                             @RequestParam(defaultValue = "1") int page,
                             @RequestParam(defaultValue = "20") int size) {
        int offset = (page - 1) * size;
        int total = aiChatHistoryMapper.countByUserId(userId);
        java.util.List<AIChatHistory> list = aiChatHistoryMapper.selectByUserId(userId, offset, size);
        Map<String, Object> data = new HashMap<>();
        data.put("total", total);
        data.put("records", list);
        return Result.success(data);
    }
} 