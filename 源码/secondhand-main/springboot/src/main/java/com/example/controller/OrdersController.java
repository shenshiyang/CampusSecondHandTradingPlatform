package com.example.controller;

import cn.hutool.core.lang.Dict;
import com.example.common.Result;
import com.example.entity.Orders;
import com.example.service.OrdersService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.util.List;

/**
 * 订单信息前端操作接口
 **/
@RestController
@RequestMapping("/orders")
public class OrdersController {

    @Resource
    private OrdersService ordersService;

    /**
     * 新增
     */
    @PostMapping("/add")
    public Result add(@RequestBody Orders orders) throws InterruptedException {
        ordersService.add(orders);
        return Result.success();
    }

    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        ordersService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        ordersService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody Orders orders) throws InterruptedException {
        System.out.println("orders.update:" + orders);
        ordersService.updateById(orders);
        return Result.success();
    }

    /**
     * 根据ID查询
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        Orders orders = ordersService.selectById(id);
        return Result.success(orders);
    }

    /**
     * 查询所有
     */
    @GetMapping("/selectAll")
    public Result selectAll(Orders orders) {
        List<Orders> list = ordersService.selectAll(orders);
        return Result.success(list);
    }

    /**
     * 分页查询
     */
    @GetMapping("/selectPage")
    public Result selectPage(Orders orders,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Orders> page = ordersService.selectPage(orders, pageNum, pageSize);
        return Result.success(page);
    }

    /**
     * 卖家的分页查询
     */
    @GetMapping("/selectSalePage")
    public Result selectSalePage(Orders orders,
                                 @RequestParam(defaultValue = "1") Integer pageNum,
                                 @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Orders> page = ordersService.selectSalePage(orders, pageNum, pageSize);
        return Result.success(page);
    }

    /**
     * 查询折线图数据
     */
    @GetMapping("/selectLine")
    public Result selectLine() {
        List<Dict> dictList = ordersService.selectLine();
        return Result.success(dictList);
    }

    /**
     * 查询柱状图数据
     */
    @GetMapping("/selectBar")
    public Result selectBar(@RequestParam(required = false) String dateType) {
        List<Dict> dictList = ordersService.selectBarByType(dateType);
        return Result.success(dictList);
    }

    @GetMapping("/selectCategorySalesCount")
    public Result selectCategorySalesCount(@RequestParam(required = false) String dateType) {
        List<Dict> list = ordersService.selectCategorySalesCountByType(dateType);
        return Result.success(list);
    }

    @GetMapping("/todayTotal")
    public Result todayTotal(@RequestParam(required = false) String dateType) {
        return Result.success(ordersService.getPeriodSalesTotal(dateType));
    }

    @GetMapping("/todayCount")
    public Result todayCount(@RequestParam(required = false) String dateType) {
        return Result.success(ordersService.getPeriodOrderCount(dateType));
    }

    @GetMapping("/lineWithCount")
    public Result lineWithCount(@RequestParam(required = false) String dateType) {
        return Result.success(ordersService.selectLineWithCountByType(dateType));
    }

}