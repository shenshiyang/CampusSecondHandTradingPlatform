package com.example.mapper;

import com.example.entity.AIChatHistory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface AIChatHistoryMapper {
    void insert(AIChatHistory history);
    List<AIChatHistory> selectByUserId(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);
    int countByUserId(@Param("userId") Long userId);
} 