package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.common.enums.RoleEnum;
import com.example.common.enums.StatusEnum;
import com.example.entity.Account;
import com.example.entity.Collect;
import com.example.entity.Goods;
import com.example.entity.Likes;
import com.example.mapper.CollectMapper;
import com.example.mapper.GoodsMapper;
import com.example.mapper.LikesMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * 二手商品业务处理
 **/
@Service
public class GoodsService {

    @Resource
    private GoodsMapper goodsMapper;
    @Resource
    private LikesMapper likesMapper;
    @Resource
    private CollectMapper collectMapper;
    @Resource
    private GoodsCacheService goodsCacheService;

    /**
     * 新增商品（包括库存）
     */
    public void add(Goods goods) {
        goods.setDate(DateUtil.today());
        Account currentUser = TokenUtils.getCurrentUser();
        goods.setUserId(currentUser.getId());
        goods.setStatus(StatusEnum.NOT_AUDIT.value);
        goods.setReadCount(0);
        if (goods.getStock() == null) {
            goods.setStock(1); // 默认库存为1
        }
        goods.setSaleStatus("上架"); // 默认上架
        goodsMapper.insert(goods);
    }

    /**
     * 删除商品
     */
    public void deleteById(Integer id) {
        goodsMapper.deleteById(id);
        // 删除缓存
        goodsCacheService.deleteGoodsCache(id.longValue());
        goodsCacheService.deleteHotGoodsCache();
    }

    /**
     * 批量删除商品
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            goodsMapper.deleteById(id);
        }
    }

    /**
     * 修改商品信息（用户修改需重新审核）
     */
    public void updateById(Goods goods) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (RoleEnum.USER.name().equals(currentUser.getRole())) {
            goods.setStatus(StatusEnum.NOT_AUDIT.value); // 用户修改商品需重新审核
        }
        goodsMapper.updateById(goods);
        // 更新后删除缓存
        goodsCacheService.deleteGoodsCache(goods.getId().longValue());
        goodsCacheService.deleteHotGoodsCache();
    }

    /**
     * 更新库存和上下架状态（不影响审核状态）
     */
    public void updateStockAndSaleStatus(Goods goods) {
        goodsMapper.updateStockAndSaleStatus(goods);
        // 删除单个商品缓存
        goodsCacheService.deleteGoodsCache(goods.getId().longValue());
        // 删除热门商品列表缓存，保证列表展示同步
        goodsCacheService.deleteHotGoodsCache();
    }

    /**
     * 根据ID查询商品（带缓存）
     */
    @Transactional(rollbackFor =Exception.class)
    public Goods selectById(Integer id)  {
        // 先从缓存中获取
        Goods cachedGoods = (Goods) goodsCacheService.getCachedGoods(id.longValue());
        if (cachedGoods != null) {
            return cachedGoods;
        }

        // 缓存未命中，从数据库查询
        Goods goods = goodsMapper.selectByIdForUpdate(id);
        Account currentUser = TokenUtils.getCurrentUser();
        goods.setUserLikes(likesMapper.selectByUserIdAndFid(currentUser.getId(), id) != null);
        goods.setLikesCount(likesMapper.selectCountByFid(id));
        goods.setUserCollect(collectMapper.selectByUserIdAndFid(currentUser.getId(), id) != null);
        goods.setCollectCount(collectMapper.selectCountByFid(id));

        // 将查询结果存入缓存
        goodsCacheService.cacheGoods(id.longValue(), goods);
        return goods;
    }

    /**
     * 查询所有商品
     */
    public List<Goods> selectAll(Goods goods) {
        return goodsMapper.selectAll(goods);
    }

    /**
     * 后台分页查询
     */
    public PageInfo<Goods> selectPage(Goods goods, Integer pageNum, Integer pageSize) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (RoleEnum.USER.name().equals(currentUser.getRole())) {
            goods.setUserId(currentUser.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Goods> list = goodsMapper.selectAll(goods);
        return PageInfo.of(list);
    }

    /**
     * 前台分页查询（带热门商品缓存）
     */
    public PageInfo<Goods> selectFrontPage(Goods goods, Integer pageNum, Integer pageSize) {
        Account currentUser = TokenUtils.getCurrentUser();
        boolean isUser = RoleEnum.USER.name().equals(currentUser.getRole());
        // 只有非用户且第一页且无筛选条件时才用热门商品缓存
        if (!isUser && pageNum == 1 && goods.getCategory() == null && goods.getName() == null) {
            List<Goods> cachedHotGoods = (List<Goods>) goodsCacheService.getCachedHotGoods();
            if (cachedHotGoods != null) {
                return new PageInfo<>(cachedHotGoods);
            }
        }
        if (isUser) {
            goods.setUserId(currentUser.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Goods> list = goodsMapper.selectFrontAll(goods);
        for (Goods g : list) {
            g.setLikesCount(likesMapper.selectCountByFid(g.getId()));
        }
        // 只有非用户且第一页且无筛选条件时才缓存热门商品
        if (!isUser && pageNum == 1 && goods.getCategory() == null && goods.getName() == null) {
            goodsCacheService.cacheHotGoods(list);
        }
        return PageInfo.of(list);
    }

    /**
     * 浏览量 +1
     */
    public void updateReadCount(Integer id) {
        goodsMapper.updateReadCount(id);
        // 删除商品详情缓存，保证下次读取是最新浏览量
        goodsCacheService.deleteGoodsCache(id.longValue());
        // 删除热门商品列表缓存，保证首页展示同步
        goodsCacheService.deleteHotGoodsCache();
    }
}
