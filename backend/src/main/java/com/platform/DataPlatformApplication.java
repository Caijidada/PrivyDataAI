package com.platform;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.platform.mapper")
public class DataPlatformApplication {

    public static void main(String[] args) {
        SpringApplication.run(DataPlatformApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("  数据协作平台启动成功！");
        System.out.println("  访问地址: http://localhost:8080");
        System.out.println("========================================\n");
    }
}