package com.czu.course_snap_backend.controller;

import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/member")
public class UserInfoController {
    @PostMapping("/login")
    public Result login(@RequestBody UserInfo userInfo) {
        log.warn("用户登录,account:{},password:{}", userInfo.getAccount(), userInfo.getPassword());
        return Result.success();
    }

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
