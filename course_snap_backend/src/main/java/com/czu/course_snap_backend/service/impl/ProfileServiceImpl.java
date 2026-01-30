package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ProfileMapper;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.UserInfo;
import com.czu.course_snap_backend.service.ProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
            List<UserInfo> userInfo = profileMapper.getUserProfile();
            if (userInfo == null) {
                return Result.error("0", "用户不存在");
            }
            return Result.success(userInfo);
        }
        return Result.error("0", "权限不足");
    }
}
