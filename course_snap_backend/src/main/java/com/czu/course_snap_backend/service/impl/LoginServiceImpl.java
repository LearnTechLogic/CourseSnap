package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.LoginMapper;
import com.czu.course_snap_backend.pojo.Login;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.ManagerInfo;
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
    public Result managerLogin(Login login) {
        ManagerInfo managerInfo = loginMapper.login(login);
        if (managerInfo == null) {
            return Result.error("0", "账号或密码错误");
        }else {
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put("id", managerInfo.getAccount());
            dataMap.put("identity", managerInfo.getIdentity());
            String jwt = JwtUtils.generateJwt(dataMap);
            managerInfo.setToken(jwt);
            return Result.success(managerInfo);
        }
    }
}
