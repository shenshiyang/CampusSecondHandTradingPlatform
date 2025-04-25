package com.example.service;

import cn.hutool.core.date.DateField;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.lang.Dict;
import cn.hutool.core.util.RandomUtil;
import com.example.common.enums.OrderStatusEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.Address;
import com.example.entity.Goods;
import com.example.entity.Orders;
import com.example.mapper.OrdersMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class OrdersService {

    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private GoodsService goodsService;
    @Resource
    private AddressService addressService;

    // 商品锁池：防止并发下单导致库存为负
    private final Map<Integer, Object> goodsLockMap = new HashMap<>();

    /**
     * 新增订单（包含库存扣减 + 并发锁控制 + 自动下架）
     */
    public void add(Orders orders) throws InterruptedException {
        Integer goodsId = orders.getGoodsId();
        Object lock = goodsLockMap.computeIfAbsent(goodsId, k -> new Object());

        synchronized (lock) {
            Goods goods = goodsService.selectById(goodsId);
            if (goods == null) {
                throw new RuntimeException("商品不存在");
            }

            Integer stock = goods.getStock() == null ? 0 : goods.getStock();
            if (stock <= 0) {
                throw new RuntimeException("库存不足，无法下单");
            }

            // 扣减库存
            goods.setStock(stock - 1);

            // 如果减完后库存为 0，则自动下架（不影响审核状态）
            if (goods.getStock() == 0) {
                goods.setSaleStatus("下架");
            }

            // ✅ 只更新库存和上下架状态，防止误改 status
            goodsService.updateStockAndSaleStatus(goods);
        }

        // 设置订单信息
        Goods latestGoods = goodsService.selectById(goodsId);
        orders.setGoodsName(latestGoods.getName());
        orders.setGoodsImg(latestGoods.getImg());
        orders.setSaleId(latestGoods.getUserId());
        orders.setTotal(latestGoods.getPrice());
        orders.setGoodsId(latestGoods.getId());

        Address address = addressService.selectById(orders.getAddressId());
        orders.setUserName(address.getUserName());
        orders.setAddress(address.getAddress());
        orders.setPhone(address.getPhone());

        Account currentUser = TokenUtils.getCurrentUser();
        orders.setUserId(currentUser.getId());
        orders.setStatus(OrderStatusEnum.NOTPAY.value);
        orders.setOrderNo(System.currentTimeMillis() + RandomUtil.randomNumbers(7));
        orders.setTime(DateUtil.now());

        ordersMapper.insert(orders);
    }

    /**
     * 取消订单（恢复库存 + 自动上架）
     */
    public void cancelOrder(Integer orderId) {
        Orders order = ordersMapper.selectById(orderId);
        if (order != null && OrderStatusEnum.NOTPAY.value.equals(order.getStatus())) {
            order.setStatus(OrderStatusEnum.CANCEL.value);
            ordersMapper.updateById(order);

            // 恢复库存并重新上架（不影响审核状态）
            Goods goods = goodsService.selectById(order.getGoodsId());
            if (goods != null) {
                int stock = goods.getStock() == null ? 0 : goods.getStock();
                goods.setStock(stock + 1);
                goods.setSaleStatus("上架");

                // ✅ 只更新库存和上下架状态，防止误改 status
                goodsService.updateStockAndSaleStatus(goods);
            }
        }
    }

    public void deleteById(Integer id) {
        ordersMapper.deleteById(id);
    }

    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            ordersMapper.deleteById(id);
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateById(Orders orders) throws InterruptedException {
        Goods goods = goodsService.selectById(orders.getGoodsId());
        goods.setStock(goods.getStock() + 1);
        goods.setSaleStatus("上架");
        goodsService.updateStockAndSaleStatus(goods);
        ordersMapper.updateById(orders);
    }

    public Orders selectById(Integer id) {
        return ordersMapper.selectById(id);
    }

    public List<Orders> selectAll(Orders orders) {
        return ordersMapper.selectAll(orders);
    }

    public PageInfo<Orders> selectPage(Orders orders, Integer pageNum, Integer pageSize) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (RoleEnum.USER.name().equals(currentUser.getRole())) {
            orders.setUserId(currentUser.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Orders> list = ordersMapper.selectAll(orders);
        return PageInfo.of(list);
    }

    public PageInfo<Orders> selectSalePage(Orders orders, Integer pageNum, Integer pageSize) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (RoleEnum.USER.name().equals(currentUser.getRole())) {
            orders.setSaleId(currentUser.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Orders> list = ordersMapper.selectAll(orders);
        return PageInfo.of(list);
    }

    public void updateByOrderNo(Orders orders) {
        ordersMapper.updateByOrderNo(orders);
    }

    public Orders selectByOrderNo(String orderNo) {
        return ordersMapper.selectByOrderNo(orderNo);
    }

    public List<Dict> selectLine() {
        List<Dict> dictList = new ArrayList<>();
        List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(orders -> OrderStatusEnum.DONE.value.equals(orders.getStatus()))
                .collect(Collectors.toList());

        Date date = new Date();
        DateTime start = DateUtil.offsetDay(date, -8);
        DateTime end = DateUtil.offsetDay(date, -1);
        List<DateTime> dateTimes = DateUtil.rangeToList(start, end, DateField.DAY_OF_YEAR);
        List<String> dateList = dateTimes.stream().map(DateUtil::formatDate).sorted().collect(Collectors.toList());

        for (String day : dateList) {
            BigDecimal total = ordersList.stream()
                    .filter(orders -> orders.getTime().contains(day))
                    .map(Orders::getTotal)
                    .reduce(BigDecimal::add)
                    .orElse(BigDecimal.ZERO);
            dictList.add(Dict.create().set("name", day).set("value", total));
        }

        return dictList;
    }

    public List<Dict> selectBar() {
        List<Dict> dictList = new ArrayList<>();
        List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(orders -> OrderStatusEnum.DONE.value.equals(orders.getStatus()))
                .collect(Collectors.toList());

        Set<String> saleList = ordersList.stream().map(Orders::getSaleName).collect(Collectors.toSet());

        for (String sale : saleList) {
            BigDecimal total = ordersList.stream()
                    .filter(orders -> sale.equals(orders.getSaleName()))
                    .map(Orders::getTotal)
                    .reduce(BigDecimal::add)
                    .orElse(BigDecimal.ZERO);
            dictList.add(Dict.create().set("name", sale).set("value", total));
        }

        return dictList;
    }

    public List<Dict> selectCategorySalesCount() {
        return ordersMapper.selectCategorySalesCount();
    }

    public BigDecimal getTodaySalesTotal() {
        String today = DateUtil.today(); // 例如：2025-04-25
        List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .filter(o -> o.getTime() != null && o.getTime().startsWith(today))
                .collect(Collectors.toList());

        return ordersList.stream()
                .map(Orders::getTotal)
                .reduce(BigDecimal::add)
                .orElse(BigDecimal.ZERO);
    }

    public Integer getTodayOrderCount() {
        String today = DateUtil.today(); // 例如 2025-04-25
        return (int) ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .filter(o -> o.getTime() != null && o.getTime().startsWith(today))
                .count();
    }

    public List<Dict> selectLineWithCount() {
        List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .collect(Collectors.toList());

        Date date = new Date();
        DateTime start = DateUtil.offsetDay(date, -8);
        DateTime end = DateUtil.offsetDay(date, -1);
        List<DateTime> dateTimes = DateUtil.rangeToList(start, end, DateField.DAY_OF_YEAR);
        List<String> dateList = dateTimes.stream().map(DateUtil::formatDate).collect(Collectors.toList());

        List<Dict> dictList = new ArrayList<>();
        for (String day : dateList) {
            BigDecimal total = ordersList.stream()
                    .filter(o -> o.getTime() != null && o.getTime().contains(day))
                    .map(Orders::getTotal)
                    .reduce(BigDecimal::add)
                    .orElse(BigDecimal.ZERO);
            long count = ordersList.stream()
                    .filter(o -> o.getTime() != null && o.getTime().contains(day))
                    .count();

            dictList.add(Dict.create()
                    .set("name", day)
                    .set("sales", total)
                    .set("count", count));
        }

        return dictList;
    }

}
