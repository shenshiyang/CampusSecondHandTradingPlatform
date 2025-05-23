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
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
        orders.setUserName(address.getName());
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

    public List<Dict> selectLineWithCount(String startDate, String endDate) {
        List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .filter(o -> {
                    if (o.getTime() == null) return false;
                    String date = o.getTime().substring(0, 10);
                    return (startDate == null || date.compareTo(startDate) >= 0)
                        && (endDate == null || date.compareTo(endDate) <= 0);
                })
                .collect(Collectors.toList());

        // 生成区间内所有日期
        List<String> dateList = new ArrayList<>();
        if (startDate != null && endDate != null) {
            DateTime start = DateUtil.parseDate(startDate);
            DateTime end = DateUtil.parseDate(endDate);
            List<DateTime> dateTimes = DateUtil.rangeToList(start, end, DateField.DAY_OF_YEAR);
            dateList = dateTimes.stream().map(DateUtil::formatDate).collect(Collectors.toList());
        } else {
            Date date = new Date();
            DateTime start = DateUtil.offsetDay(date, -8);
            DateTime end = DateUtil.offsetDay(date, -1);
            List<DateTime> dateTimes = DateUtil.rangeToList(start, end, DateField.DAY_OF_YEAR);
            dateList = dateTimes.stream().map(DateUtil::formatDate).collect(Collectors.toList());
        }

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
            dictList.add(Dict.create().set("name", day).set("sales", total).set("count", count));
        }
        return dictList;
    }

    public List<Dict> selectBar(String startDate, String endDate) {
        List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(orders -> OrderStatusEnum.DONE.value.equals(orders.getStatus()))
                .filter(o -> {
                    if (o.getTime() == null) return false;
                    String date = o.getTime().substring(0, 10);
                    return (startDate == null || date.compareTo(startDate) >= 0)
                        && (endDate == null || date.compareTo(endDate) <= 0);
                })
                .collect(Collectors.toList());
        Set<String> saleList = ordersList.stream().map(Orders::getSaleName).collect(Collectors.toSet());
        List<Dict> dictList = new ArrayList<>();
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

    public List<Dict> selectCategorySalesCount(String startDate, String endDate) {
        // 如果需要时间区间，可以扩展Mapper SQL，这里直接调用SQL，统计商品种类销量
        return ordersMapper.selectCategorySalesCount();
    }

    public BigDecimal getPeriodSalesTotal(String dateType) {
        String[] range = getDateRangeByType(dateType);
        List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .filter(o -> o.getTime() != null && o.getTime().length() >= 10 && o.getTime().substring(0, 10).compareTo(range[0]) >= 0 && o.getTime().substring(0, 10).compareTo(range[1]) <= 0)
                .collect(Collectors.toList());
        return ordersList.stream().map(Orders::getTotal).reduce(BigDecimal::add).orElse(BigDecimal.ZERO);
    }

    public Integer getPeriodOrderCount(String dateType) {
        String[] range = getDateRangeByType(dateType);
        return (int) ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .filter(o -> o.getTime() != null && o.getTime().length() >= 10 && o.getTime().substring(0, 10).compareTo(range[0]) >= 0 && o.getTime().substring(0, 10).compareTo(range[1]) <= 0)
                .count();
    }

    private String[] getDateRangeByType(String dateType) {
        LocalDate now = LocalDate.now();
        String start, end;
        if ("day".equals(dateType)) {
            start = now.toString();
            end = now.toString();
        } else if ("month".equals(dateType)) {
            start = now.withDayOfMonth(1).toString();
            end = now.withDayOfMonth(now.lengthOfMonth()).toString();
        } else if ("year".equals(dateType)) {
            start = now.withDayOfYear(1).toString();
            end = now.withDayOfYear(now.lengthOfYear()).toString();
        } else { // 默认周
            start = now.with(DayOfWeek.MONDAY).toString();
            end = now.with(DayOfWeek.SUNDAY).toString();
        }
        return new String[]{start, end};
    }

    public List<Dict> selectBarByType(String dateType) {
        if ("month".equals(dateType)) {
            String[] range = getDateRangeByType("month");
            return selectBar(range[0], range[1]);
        }
        if ("year".equals(dateType)) {
            List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .collect(Collectors.toList());
            int currentYear = LocalDate.now().getYear();
            List<Dict> dictList = new ArrayList<>();
            for (int i = 4; i >= 0; i--) {
                int year = currentYear - i;
                String yearStr = String.valueOf(year);
                Map<String, BigDecimal> saleMap = new HashMap<>();
                for (Orders o : ordersList) {
                    if (o.getTime() != null && o.getTime().startsWith(yearStr)) {
                        String sale = o.getSaleName();
                        saleMap.put(sale, saleMap.getOrDefault(sale, BigDecimal.ZERO).add(o.getTotal()));
                    }
                }
                for (Map.Entry<String, BigDecimal> entry : saleMap.entrySet()) {
                    dictList.add(Dict.create().set("name", entry.getKey() + " (" + yearStr + ")").set("value", entry.getValue()));
                }
            }
            return dictList;
        }
        String[] range = getDateRangeByType(dateType);
        return selectBar(range[0], range[1]);
    }
    public List<Dict> selectCategorySalesCountByType(String dateType) {
        if ("month".equals(dateType)) {
            String[] range = getDateRangeByType("month");
            return ordersMapper.selectCategorySalesCountByRange(range[0], range[1]);
        }
        if ("year".equals(dateType)) {
            List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .collect(Collectors.toList());
            int currentYear = LocalDate.now().getYear();
            Map<String, Long> categoryMap = new LinkedHashMap<>();
            for (int i = 4; i >= 0; i--) {
                int year = currentYear - i;
                String yearStr = String.valueOf(year);
                Map<String, Long> yearCategory = new HashMap<>();
                for (Orders o : ordersList) {
                    if (o.getTime() != null && o.getTime().startsWith(yearStr)) {
                        String category = o.getCategory();
                        yearCategory.put(category, yearCategory.getOrDefault(category, 0L) + 1);
                    }
                }
                for (Map.Entry<String, Long> entry : yearCategory.entrySet()) {
                    String key = entry.getKey() + " (" + yearStr + ")";
                    categoryMap.put(key, entry.getValue());
                }
            }
            List<Dict> result = new ArrayList<>();
            for (Map.Entry<String, Long> entry : categoryMap.entrySet()) {
                result.add(Dict.create().set("name", entry.getKey()).set("value", entry.getValue()));
            }
            return result;
        }
        String[] range = getDateRangeByType(dateType);
        return ordersMapper.selectCategorySalesCountByRange(range[0], range[1]);
    }
    public List<Dict> selectLineWithCountByType(String dateType) {
        if ("month".equals(dateType)) {
            List<Dict> dictList = new ArrayList<>();
            List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .collect(Collectors.toList());
            LocalDate now = LocalDate.now();
            DateTimeFormatter ymFmt = DateTimeFormatter.ofPattern("yyyy-MM");
            for (int i = 11; i >= 0; i--) {
                LocalDate month = now.minusMonths(i);
                String ym = month.format(ymFmt);
                BigDecimal total = ordersList.stream()
                    .filter(o -> o.getTime() != null && o.getTime().startsWith(ym))
                    .map(Orders::getTotal)
                    .reduce(BigDecimal::add)
                    .orElse(BigDecimal.ZERO);
                long count = ordersList.stream()
                    .filter(o -> o.getTime() != null && o.getTime().startsWith(ym))
                    .count();
                dictList.add(Dict.create().set("name", ym).set("sales", total).set("count", count));
            }
            return dictList;
        }
        if ("year".equals(dateType)) {
            List<Dict> dictList = new ArrayList<>();
            List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .collect(Collectors.toList());
            int currentYear = LocalDate.now().getYear();
            for (int i = 4; i >= 0; i--) {
                int year = currentYear - i;
                String yearStr = String.valueOf(year);
                BigDecimal total = ordersList.stream()
                    .filter(o -> o.getTime() != null && o.getTime().startsWith(yearStr))
                    .map(Orders::getTotal)
                    .reduce(BigDecimal::add)
                    .orElse(BigDecimal.ZERO);
                long count = ordersList.stream()
                    .filter(o -> o.getTime() != null && o.getTime().startsWith(yearStr))
                    .count();
                dictList.add(Dict.create().set("name", yearStr).set("sales", total).set("count", count));
            }
            return dictList;
        }
        if ("week".equals(dateType)) {
            // 近七天（不含今天）
            List<Dict> dictList = new ArrayList<>();
            List<Orders> ordersList = ordersMapper.selectAll(null).stream()
                .filter(o -> OrderStatusEnum.DONE.value.equals(o.getStatus()))
                .collect(Collectors.toList());
            List<String> dateList = new ArrayList<>();
            LocalDate now = LocalDate.now();
            for (int i = 7; i >= 1; i--) {
                dateList.add(now.minusDays(i).toString());
            }
            for (String day : dateList) {
                BigDecimal total = ordersList.stream()
                    .filter(o -> o.getTime() != null && o.getTime().startsWith(day))
                    .map(Orders::getTotal)
                    .reduce(BigDecimal::add)
                    .orElse(BigDecimal.ZERO);
                long count = ordersList.stream()
                    .filter(o -> o.getTime() != null && o.getTime().startsWith(day))
                    .count();
                dictList.add(Dict.create().set("name", day).set("sales", total).set("count", count));
            }
            return dictList;
        }
        String[] range = getDateRangeByType(dateType);
        return selectLineWithCount(range[0], range[1]);
    }

}
