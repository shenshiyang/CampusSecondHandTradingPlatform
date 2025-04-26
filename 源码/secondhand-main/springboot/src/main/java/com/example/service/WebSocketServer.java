package com.example.service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.example.entity.ChatInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * websocket服务
 */
@ServerEndpoint(value = "/chatServer/{userId}")
@Component
public class WebSocketServer {
    private static final Logger log = LoggerFactory.getLogger(WebSocketServer.class);
    
    private static ChatInfoService chatInfoService;
    
    @Resource
    public void setChatInfoService(ChatInfoService service) {
        WebSocketServer.chatInfoService = service;
    }
    
    /**
     * 记录当前在线连接数
     */
    public static final Map<Integer, Session> sessionMap = new ConcurrentHashMap<>();

    /**
     * 连接建立成功调用的方法
     */
    @OnOpen
    public void onOpen(Session session, @PathParam("userId") Integer userId) {
        sessionMap.put(userId, session);
        log.info("有新用户加入，userId={}, 当前在线人数为：{}", userId, sessionMap.size());
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose(Session session, @PathParam("userId") Integer userId) {
        sessionMap.remove(userId);
        log.info("有一连接关闭，移除userId={}的用户session, 当前在线人数为：{}", userId, sessionMap.size());
    }

    /**
     * 收到客户端消息后调用的方法
     */
    @OnMessage
    public void onMessage(String message) {
        try {
            JSONObject jsonObject = JSON.parseObject(message);
            String type = jsonObject.getString("type");
            
            if ("heartbeat".equals(type)) {
                // 处理心跳消息
                return;
            }
            
            if ("chat".equals(type)) {
                // 解析消息内容
                Integer fromUserId = jsonObject.getInteger("fromUserId");
                Integer toUserId = jsonObject.getInteger("toUserId");
                String content = jsonObject.getString("content");
                String contentType = jsonObject.getString("contentType");
                String fileType = jsonObject.getString("fileType");
                String fileUrl = jsonObject.getString("fileUrl");
                Integer messageId = jsonObject.getInteger("messageId");
                
                // 发送消息给接收方
                Session toSession = sessionMap.get(toUserId);
                if (toSession != null && toSession.isOpen()) {
                    toSession.getAsyncRemote().sendText(message);
                    log.info("消息已转发给用户 {}", toUserId);
                } else {
                    log.info("用户 {} 不在线，消息将被保存为离线消息", toUserId);
                }

                // 如果消息没有messageId，说明是直接通过WebSocket发送的消息，需要保存
                if (messageId == null) {
                    ChatInfo chatInfo = new ChatInfo();
                    chatInfo.setUserId(fromUserId);
                    chatInfo.setChatUserId(toUserId);
                    chatInfo.setText(content);
                    chatInfo.setContentType(contentType);
                    chatInfo.setFileType(fileType);
                    chatInfo.setFileUrl(fileUrl);
                    chatInfo.setIsread("否");
                    
                    try {
                        chatInfoService.add(chatInfo);
                        
                        // 构造确认消息
                        JSONObject ack = new JSONObject();
                        ack.put("type", "ack");
                        ack.put("messageId", chatInfo.getId());
                        ack.put("status", "success");
                        
                        // 发送确认消息给发送方
                        Session fromSession = sessionMap.get(fromUserId);
                        if (fromSession != null && fromSession.isOpen()) {
                            fromSession.getAsyncRemote().sendText(ack.toJSONString());
                        }
                        
                        // 更新原始消息中的messageId并重新发送给接收方
                        if (toSession != null && toSession.isOpen()) {
                            jsonObject.put("messageId", chatInfo.getId());
                            toSession.getAsyncRemote().sendText(jsonObject.toJSONString());
                        }
                    } catch (Exception e) {
                        log.error("保存消息失败", e);
                        
                        // 发送失败通知给发送方
                        JSONObject fail = new JSONObject();
                        fail.put("type", "ack");
                        fail.put("status", "error");
                        fail.put("error", "消息保存失败");
                        
                        Session fromSession = sessionMap.get(fromUserId);
                        if (fromSession != null && fromSession.isOpen()) {
                            fromSession.getAsyncRemote().sendText(fail.toJSONString());
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.error("处理Socket消息失败", e);
        }
    }

    @OnError
    public void onError(Session session, Throwable error) {
        log.error("Socket错误", error);
        try {
            if (session.isOpen()) {
                session.close();
            }
        } catch (Exception e) {
            log.error("关闭Socket连接失败", e);
        }
    }

    /**
     * 发送消息给指定用户
     */
    public static void sendMessage(Integer userId, String message) {
        Session session = sessionMap.get(userId);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (Exception e) {
                log.error("Socket发送消息失败", e);
            }
        }
    }
}

