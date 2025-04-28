package com.example.service;

import com.example.entity.Goods;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class GoodsCacheService {

    private static final String GOODS_KEY_PREFIX = "goods:";
    private static final String HOT_GOODS_KEY = "hot:goods";
    private static final long GOODS_CACHE_TIME = 30; // 商品缓存时间（分钟）
    private static final long HOT_GOODS_CACHE_TIME = 60; // 热门商品缓存时间（分钟）

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    /**
     * 缓存商品信息
     */
    public void cacheGoods(Long goodsId, Object goodsInfo) {
        String key = GOODS_KEY_PREFIX + goodsId;
        redisTemplate.opsForValue().set(key, goodsInfo, GOODS_CACHE_TIME, TimeUnit.MINUTES);
    }

    /**
     * 获取缓存的商品信息
     */
    public Goods getCachedGoods(Long goodsId) {
        String key = GOODS_KEY_PREFIX + goodsId;
        Object obj = redisTemplate.opsForValue().get(key);
        if (obj == null) return null;
        if (obj instanceof Goods) {
            return (Goods) obj;
        }
        // 关键：将LinkedHashMap转为Goods
        return objectMapper.convertValue(obj, Goods.class);
    }

    /**
     * 删除商品缓存
     */
    public void deleteGoodsCache(Long goodsId) {
        String key = GOODS_KEY_PREFIX + goodsId;
        redisTemplate.delete(key);
    }

    /**
     * 缓存热门商品
     */
    public void cacheHotGoods(Object hotGoods) {
        redisTemplate.opsForValue().set(HOT_GOODS_KEY, hotGoods, HOT_GOODS_CACHE_TIME, TimeUnit.MINUTES);
    }

    /**
     * 获取缓存的热门商品
     */
    public Object getCachedHotGoods() {
        return redisTemplate.opsForValue().get(HOT_GOODS_KEY);
    }

    /**
     * 删除热门商品缓存
     */
    public void deleteHotGoodsCache() {
        redisTemplate.delete(HOT_GOODS_KEY);
    }
} 