package com.platform.controller;

import com.platform.common.Result;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;
@CrossOrigin(origins = "http://localhost:5173")

/**
 * 测试接口
 */
@RestController
@RequestMapping("/api/test")
public class TestController {

    /**
     * 健康检查
     */
    @GetMapping("/health")
    public Result<String> health() {
        return Result.success("系统运行正常");
    }

    /**
     * 获取系统信息
     */
    @GetMapping("/info")
    public Result<Map<String, Object>> info() {
        Map<String, Object> info = new HashMap<>();
        info.put("name", "企业数据智能协作平台");
        info.put("version", "1.0.0");
        info.put("author", "caijidada");
        info.put("javaVersion", System.getProperty("java.version"));
        return Result.success(info);
    }
}