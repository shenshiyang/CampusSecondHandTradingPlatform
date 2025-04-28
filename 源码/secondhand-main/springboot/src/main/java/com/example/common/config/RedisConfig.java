package com.example.common.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfig {
    
    private static final Logger logger = LoggerFactory.getLogger(RedisConfig.class);

    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        try {
            RedisTemplate<String, Object> template = new RedisTemplate<>();
            template.setConnectionFactory(factory);
            
            // 设置key的序列化方式
            template.setKeySerializer(new StringRedisSerializer());
            // 设置value的序列化方式
            template.setValueSerializer(new Jackson2JsonRedisSerializer<>(Object.class));
            
            template.setHashKeySerializer(new StringRedisSerializer());
            template.setHashValueSerializer(new Jackson2JsonRedisSerializer<>(Object.class));
            
            template.afterPropertiesSet();
            logger.info("RedisTemplate配置成功");
            return template;
        } catch (Exception e) {
            logger.error("RedisTemplate配置失败", e);
            throw e;
        }
    }
} 