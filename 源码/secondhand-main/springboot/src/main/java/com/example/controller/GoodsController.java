package com.example.controller;

import com.example.common.Result;
import com.example.entity.Goods;
import com.example.service.GoodsService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/goods")
public class GoodsController {

    @Resource
    private GoodsService goodsService;

    // ✅ 发布商品
    @PostMapping("/add")
    public Result add(@RequestBody Goods goods) {
        goodsService.add(goods);
        return Result.success();
    }

    // ✅ 删除商品
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        goodsService.deleteById(id);
        return Result.success();
    }

    // ✅ 批量删除
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        goodsService.deleteBatch(ids);
        return Result.success();
    }

    // ✅ 修改商品（用户端触发时会置为待审核）
    @PutMapping("/update")
    public Result updateById(@RequestBody Goods goods) {
        goodsService.updateById(goods);
        return Result.success();
    }

    // ✅ 根据 ID 查询
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) throws InterruptedException {
        Goods goods = goodsService.selectById(id);
        return Result.success(goods);
    }

    // ✅ 查询全部（后台）
    @GetMapping("/selectAll")
    public Result selectAll(Goods goods) {
        List<Goods> list = goodsService.selectAll(goods);
        return Result.success(list);
    }

    // ✅ 分页查询（后台）
    @GetMapping("/selectPage")
    public Result selectPage(Goods goods,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Goods> page = goodsService.selectPage(goods, pageNum, pageSize);
        return Result.success(page);
    }

    // ✅ 分页查询（前台）
    @GetMapping("/selectFrontPage")
    public Result selectFrontPage(Goods goods,
                                  @RequestParam(defaultValue = "1") Integer pageNum,
                                  @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Goods> page = goodsService.selectFrontPage(goods, pageNum, pageSize);
        return Result.success(page);
    }

    // ✅ 更新浏览量
    @PutMapping("/updateReadCount/{id}")
    public Result updateReadCount(@PathVariable Integer id) {
        goodsService.updateReadCount(id);
        return Result.success();
    }

    // ✅ 新增：更新库存和上下架状态（卖家后台用）
    @PostMapping("/updateStockAndSaleStatus")
    public Result updateStockAndSaleStatus(@RequestBody Goods goods) {
        goodsService.updateStockAndSaleStatus(goods);
        return Result.success();
    }
}
