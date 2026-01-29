package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.LoginMapper;
import com.czu.course_snap_backend.pojo.Login;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;
import com.czu.course_snap_backend.service.LoginService;
import com.czu.course_snap_backend.untils.JwtUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
public class LoginServiceImpl implements LoginService {
    @Autowired
    private LoginMapper loginMapper;
    @Override
    public Result login(Login login) {
        UserInfo userInfo = loginMapper.login(login);
        if (userInfo == null) {
            return Result.error("0", "账号或密码错误");
        }else {
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put("id", userInfo.getAccount());
            dataMap.put("identity", userInfo.getIdentity());
            String jwt = JwtUtils.generateJwt(dataMap);
            userInfo.setToken(jwt);
            return Result.success(userInfo);
        }
    }
}
