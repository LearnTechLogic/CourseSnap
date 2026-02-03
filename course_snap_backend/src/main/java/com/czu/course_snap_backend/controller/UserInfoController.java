package com.czu.course_snap_backend.controller;

import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;
import com.czu.course_snap_backend.service.UserService;
import com.czu.course_snap_backend.untils.ThreadLocalUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/user")
public class UserInfoController {
    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public Result login(@RequestParam("account") String account, @RequestParam("password") String password) {
        if (account == null || password == null) {
            return Result.error("0", "请填写账号和密码");
        }
        return userService.login(Integer.parseInt(account), password);
    }
    @PostMapping("/register")
    public Result register(@RequestBody UserInfo userInfo) {
        if (userInfo.getAccount() <= 0 || userInfo.getPassword() == null) {
            return Result.error("0", "请填写账号和密码");
        }
        return userService.register(userInfo);
    }

    @GetMapping("/info")
    public Result getUserInfo() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int account = (int) claims.get("account");
            return userService.getUserInfo(account);
        }
        return Result.error("0", "请先登录");
    }
}
