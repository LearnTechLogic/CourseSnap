package com.czu.course_snap_backend.controller;

import com.czu.course_snap_backend.pojo.Login;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.service.LoginService;
import com.czu.course_snap_backend.service.ProfileService;
import com.czu.course_snap_backend.service.RegisterService;
import com.czu.course_snap_backend.untils.ThreadLocalUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/manager")
public class ManagerInfoController {
    @Autowired
    private LoginService loginService;
    @Autowired
    private ProfileService profileService;
    @Autowired
    private RegisterService registerService;

    @PostMapping("/login")
    public Result login(@RequestBody Login login) {
        if (login.getAccount() == null || login.getPassword() == null) {
            return Result.error("0", "请填写账号和密码");
        }
        log.warn("用户登录,account:{},password:{}", login.getAccount(), login.getPassword());
        return loginService.managerLogin(login);
    }

    @GetMapping("/profile")
    public Result getUserProfile() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int account = (int) claims.get("id");
            log.warn("获取用户信息,id:{},identity:{}", claims.get("id"), claims.get("identity"));
            return profileService.getManagerProfile(account);
        }
        log.warn("获取用户信息,未携带token");
        return Result.error("0", "请先登录");
    }

    @PostMapping("/register")
    public Result register(@RequestBody ManagerInfo managerInfo) {
        return registerService.managerRegister(managerInfo);
    }
}
