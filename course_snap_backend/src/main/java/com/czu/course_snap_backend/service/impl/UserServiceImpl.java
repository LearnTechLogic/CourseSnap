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
        if (getUserInfo(account) == null) {
            return Result.error("0", "用户不存在");
        }
        UserInfo userInfo = userMapper.login(account, password);
        if (userInfo == null) {
            return Result.error("0", "账号密码错误");
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
    @Override
    public Result updateUserInfo(UserInfo userInfo) {
        if (userMapper.getUserInfo(userInfo.getAccount()).getState().equals("已支付")) {
            return Result.error("0", "已支付不支持修改");
        }
        int i = userMapper.updateUserInfo(userInfo.getAccount(), userInfo.getName(), userInfo.getPassword(), userInfo.getPrice(), userInfo.getRequirement(), userInfo.getQq());
        if (i == 1) {
            return Result.success(userMapper.getUserInfo(userInfo.getAccount()));
        }
        return Result.error("400", "更新失败");
    }
    @Override
    public Result applyUserInfo(UserInfo userInfo) {
        UserInfo _userInfo = userMapper.getUserInfo(userInfo.getAccount());
        if (_userInfo.getPassword() == null) {
            return Result.error("0", "用户不存在");
        }
        if (userMapper.getUserInfo(userInfo.getAccount()).getState().equals("已支付")) {
            return Result.error("0", "只支付不支持修改");
        }
        int j = userMapper.updateUserInfo(userInfo.getAccount(),userInfo.getName(), userInfo.getPassword(), userInfo.getPrice(), userInfo.getRequirement(), userInfo.getQq());
        if (j != 1) {
            return Result.error("0", "更新失败");
        }
        int i = userMapper.applyUserInfo(userInfo.getAccount(), "申请");
        if (i == 1) {
            userInfo = userMapper.getUserInfo(userInfo.getAccount());
            return Result.success(userInfo);
        }
        return Result.error("0", "申请失败");
    }
}
