package com.czu.course_snap_backend.controller;

import com.czu.course_snap_backend.pojo.*;
import com.czu.course_snap_backend.service.ManagerService;
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
    private ManagerService managerService;

    @PostMapping("/login")
    public Result login(@RequestBody ManagerInfo managerInfo) {
        if (managerInfo.getAccount() <= 0 || managerInfo.getPassword() == null) {
            return Result.error("0", "请填写账号和密码");
        }
        return managerService.login(managerInfo);
    }
    @PostMapping("/register")
    public Result register(@RequestBody ManagerInfo managerInfo) {
        return managerService.register(managerInfo);
    }
    @GetMapping("/profile")
    public Result getManagerProfile() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int account = (int) claims.get("account");
            return managerService.getManagerProfile(account);
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/paid")
    public Result getUserPaidList() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int account = (int) claims.get("account");
            return managerService.getUserPaidList(account);
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/profile/list")
    public Result getManagerProfileList() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int identity = (int) claims.get("identity");
            return managerService.getManagerProfileList(identity);
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/user/manager")
    public Result getUserByManager(@RequestParam("managerId") String managerId) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int identity = (int) claims.get("identity");
            if (identity == 3) {
                return Result.error("0", "权限不足");
            }
            int account = Integer.parseInt(managerId);
            return managerService.getUserProfileByManagerId(account);
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/user/waiting")
    public Result getUserWaiting() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int identity = (int) claims.get("identity");
            if (identity == 1) {
                return managerService.getUserWaitingProfile();
            } else {
                return Result.error("0", "权限不足");
            }
        }
        return Result.error("0", "请先登录");
    }
    @PostMapping("/allocation")
    public Result updateAllocation(@RequestBody AllocationDetails allocationDetails) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int identity = (int) claims.get("identity");
            if (identity == 1) {
                return managerService.updateAllocation(allocationDetails);
            } else {
                return Result.error("0", "权限不足");
            }
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/profile/detail")
    public Result getManagerProfileDetail(@RequestParam("account") int account) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            return managerService.getManagerProfile(account);
        }
        log.warn("获取用户信息,未携带token");
        return Result.error("0", "请先登录");
    }
    @PostMapping("/profile/update")
    public Result updateManagerProfile(@RequestBody ManagerInfo managerInfo) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null && (int) claims.get("identity") == 1) {
            return managerService.updateManagerProfile(managerInfo);
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/user")
    public Result getUserProfile() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int account = (int) claims.get("account");
            int identity = (int) claims.get("identity");
            return managerService.getUserProfile(identity, account);
        }
        return Result.error("0", "请先登录");
    }
    @DeleteMapping("/user/delete")
    public Result deleteUserProfile(@RequestParam("account") int account) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int identity = (int) claims.get("identity");
            if (identity == 1 || identity == 2) {
//                return profileService.deleteUserProfile(account, identity);
                return managerService.deleteUserProfile(account, identity);
            } else {
                return Result.error("0", "权限不足");
            }
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/user/account")
    public Result getUserProfile(@RequestParam("account") int account) {
        return managerService.getUserProfileById(account);
    }
    @PostMapping("/user/update")
    public Result updateUserProfile(@RequestBody UserInfo userInfo) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int account = (int) claims.get("account");
            int identity = (int) claims.get("identity");
            if (identity == 1 || identity == 2) {
                return managerService.updateUserProfile(userInfo, account, identity);
            } else {
                return Result.error("0", "权限不足");
            }
        }
        return Result.error("0", "请先登录");
    }
}
