package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.UserMapper;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;
import com.czu.course_snap_backend.service.UserService;
import com.czu.course_snap_backend.untils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public Result login(int account, String password) {
        UserInfo userInfo = userMapper.login(account, password);
        if (userInfo == null) {
            return Result.error("400", "用户不存在");
        }
        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("account", userInfo.getAccount());
        String jwt = JwtUtils.generateJwt(dataMap);
        userInfo.setToken(jwt);
        return Result.success(userInfo);
    }
    @Override
    public Result register(UserInfo userInfo) {
        if (userMapper.getUserInfo(userInfo.getAccount()) != null) {
            return Result.error("400", "用户已存在");
        }
        int i = userMapper.register(userInfo.getAccount(), userInfo.getPassword(), "仅注册");
        if (i == 1) {
            return Result.success();
        }
        return Result.error("400", "注册失败");
    }
    @Override
    public Result getUserInfo(int account) {
        UserInfo userInfo = userMapper.getUserInfo(account);
        if (userInfo == null) {
            return Result.error("400", "用户不存在");
        }
        return Result.success(userInfo);
    }
}
