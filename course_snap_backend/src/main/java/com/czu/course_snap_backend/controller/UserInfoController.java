package com.czu.course_snap_backend.controller;

import com.czu.course_snap_backend.pojo.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/member")
public class UserInfoController {
    @GetMapping("/profile")
    public Result getUserProfile() {
        log.warn("获取用户信息,未携带token");
        return Result.error("0", "请先登录");
    }
    public Result getUserProfile(String token) {
        log.warn("获取用户信息,token:{}", token);
        return Result.success();
    }
}
