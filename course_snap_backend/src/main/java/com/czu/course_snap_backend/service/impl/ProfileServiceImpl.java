package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ProfileMapper;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.service.ProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProfileServiceImpl implements ProfileService {
    @Autowired
    private ProfileMapper profileMapper;
    @Override
    public Result getManagerProfile(int account) {
        ManagerInfo managerInfo = profileMapper.getUserProfile(account);
        if (managerInfo == null) {
            return Result.error("0", "用户不存在");
        }
        return Result.success(managerInfo);
    }
}
