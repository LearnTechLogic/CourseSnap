package com.czu.course_snap_backend;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
public class CourseSnapBackendApplication {
    public static void main(String[] args) {
        SpringApplication.run(CourseSnapBackendApplication.class, args);
    }

}
