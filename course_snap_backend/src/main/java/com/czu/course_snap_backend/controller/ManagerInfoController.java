package com.czu.course_snap_backend.controller;

import com.czu.course_snap_backend.pojo.*;
import com.czu.course_snap_backend.service.ManagerService;
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
    private ManagerService managerService;
    @Autowired
    private ProfileService profileService;

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
            return profileService.getManagerProfileList(identity);
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/profile/detail")
    public Result getManagerProfileDetail(@RequestParam("account") String account) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int accountInt = Integer.parseInt(account);
            log.warn("获取用户信息,id:{},identity:{}", claims.get("id"), claims.get("identity"));
            return profileService.getManagerProfile(accountInt);
        }
        log.warn("获取用户信息,未携带token");
        return Result.error("0", "请先登录");
    }
    @PostMapping("/profile/update")
    public Result updateManagerProfile(@RequestBody ManagerInfo managerInfo) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null && (int) claims.get("identity") == 1) {
            return profileService.updateManagerProfile(managerInfo);
        }
        return Result.error("0", "请先登录");
    }



    @GetMapping("/user")
    public Result getUserProfile() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int account = (int) claims.get("id");
            int identity = (int) claims.get("identity");
            return profileService.getUserProfile(identity, account);
        }
        return Result.error("0", "请先登录");
    }

    @GetMapping("/user/waiting")
    public Result getUserWaiting() {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int identity = (int) claims.get("identity");
            if (identity == 1) {
                return profileService.getUserWaitingProfile();
            } else {
                return Result.error("0", "权限不足");
            }
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
            return profileService.getUserProfile(2, account);
        }
        return Result.error("0", "请先登录");
    }
    @GetMapping("/user/account")
    public Result getUserProfile(@RequestParam("account") String account) {
        if (account != null) {
            int account_int = Integer.parseInt(account);
            return profileService.getUserProfile(account_int);
        }
        return Result.error("0", "请先登录");
    }
    @PostMapping("/user/update")
    public Result updateUserProfile(@RequestBody UserInfo userInfo) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int account = (int) claims.get("id");
            int identity = (int) claims.get("identity");
            if (identity == 1 || identity == 2) {
                return profileService.updateUserProfile(userInfo);
            } else {
                return Result.error("0", "权限不足");
            }
        }
        return Result.error("0", "请先登录");
    }

    @DeleteMapping("/user/delete")
    public Result deleteUserProfile(@RequestParam("account") String account) {
        Map<String, Object> claims = ThreadLocalUtil.get();
        if (claims != null) {
            int identity = (int) claims.get("identity");
            if (identity == 1 || identity == 2) {
                int account_int = Integer.parseInt(account);
                return profileService.deleteUserProfile(account_int, identity);
            } else {
                return Result.error("0", "权限不足");
            }
        }
        return Result.error("0", "请先登录");
    }

    @PostMapping("/allocation")
    public Result updateAllocation(@RequestBody AllocationDetails allocationDetails) {
        int managerAccount = allocationDetails.getManagerAccount();
        int userAccount = allocationDetails.getUserAccount();
        return profileService.updateAllocation(managerAccount, userAccount);
    }


}
