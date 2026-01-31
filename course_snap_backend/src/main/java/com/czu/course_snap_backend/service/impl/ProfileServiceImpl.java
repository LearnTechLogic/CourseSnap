package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ProfileMapper;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.UserInfo;
import com.czu.course_snap_backend.service.ProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Iterator;
import java.util.List;

@Service
public class ProfileServiceImpl implements ProfileService {
    @Autowired
    private ProfileMapper profileMapper;
    @Override
    public Result getManagerProfile(int account) {
        ManagerInfo managerInfo = profileMapper.getManagerProfile(account);
        if (managerInfo == null) {
            return Result.error("0", "用户不存在");
        }
        return Result.success(managerInfo);
    }

    @Override
    public Result getUserProfile(int identity, int account) {
        if (identity == 1) {
            List<UserInfo> userInfo = profileMapper.getUsersProfile();
            if (userInfo == null) {
                return Result.error("0", "用户不存在");
            }
            return Result.success(userInfo);
        } else if (identity == 2) {
            List<UserInfo> userInfo = profileMapper.getUserProfile(account);
            Iterator<UserInfo> iterator = userInfo.iterator();
            while (iterator.hasNext()) {
                UserInfo userInfo1 = iterator.next();
                // 判断状态等于 "name" 时移除
                if ("已支付".equals(userInfo1.getState())) { // 常量放前面，避免空指针
                    iterator.remove(); // 使用迭代器的 remove 方法，安全移除
                }
            }
            if (userInfo == null) {
                return Result.error("0", "暂无信息");
            }
            return Result.success(userInfo);
        } else {
            return Result.error("0", "权限不足");
        }
    }

    @Override
    public Result getUserProfile(int account) {
        UserInfo userInfo = profileMapper.getUserProfileById(account);
        if (userInfo == null) {
            return Result.error("0", "用户不存在");
        }
        return Result.success(userInfo);
    }

    @Override
    public Result updateUserProfile(UserInfo userInfo) {
        int update = profileMapper.updateUserProfile(userInfo);
        if (update == 0) {
            return Result.error("0", "更新失败");
        }
        return Result.success();
    }
}
