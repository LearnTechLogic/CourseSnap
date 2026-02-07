package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ManagerMapper;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;
import com.czu.course_snap_backend.service.ManagerService;
import com.czu.course_snap_backend.untils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ManagerServiceImpl implements ManagerService {
    @Autowired
    private ManagerMapper managerMapper;
    @Override
    public Result login(ManagerInfo managerInfo) {
        managerInfo = managerMapper.login(managerInfo);
        if (managerInfo == null) {
            return Result.error("0", "账号或密码错误");
        }else {
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put("account", managerInfo.getAccount());
            dataMap.put("identity", managerInfo.getIdentity());
            managerInfo.setToken(JwtUtils.generateJwt(dataMap));
            return Result.success(managerInfo);
        }
    }
    @Override
    public Result register(ManagerInfo managerInfo) {
        if (managerMapper.getManagerInfo(managerInfo.getAccount()) != null) {
            return Result.error("0", "该账号已存在");
        }
        managerInfo.setIdentity(3);
        int i = managerMapper.register(managerInfo);
        if (i == 1) {
            return Result.success(managerInfo);
        } else {
            return Result.error("0", "注册失败");
        }
    }
    @Override
    public Result getManagerProfile(int account) {
        ManagerInfo managerInfo = managerMapper.getManagerInfo(account);
        if (managerInfo == null) {
            return Result.error("0", "该账号不存在");
        }
        return Result.success(managerInfo);
    }
    @Override
    public Result getUserPaidList(int managerId) {
        List<UserInfo> userInfoList = managerMapper.getUserPaidList(managerId);
        return Result.success(userInfoList);
    }
}
