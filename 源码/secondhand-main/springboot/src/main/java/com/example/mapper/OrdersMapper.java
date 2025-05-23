package com.example.mapper;

import cn.hutool.core.lang.Dict;
import com.example.entity.Orders;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 操作orders相关数据接口
 */
public interface OrdersMapper {

    /**
     * 新增
     */
    int insert(Orders orders);

    /**
     * 删除
     */
    int deleteById(Integer id);

    /**
     * 修改
     */
    int updateById(Orders orders);

    /**
     * 根据ID查询
     */
    Orders selectById(Integer id);

    /**
     * 查询所有
     */
    List<Orders> selectAll(Orders orders);

    List<Dict> selectCategorySalesCount();

    List<Dict> selectCategorySalesCountByRange(@Param("startDate") String startDate, @Param("endDate") String endDate);

    @Select("select * from orders where order_no = #{orderNo}")
    Orders selectByOrderNo(String orderNo);

    void updateByOrderNo(Orders orders);
}

