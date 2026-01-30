package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.LoginMapper;
import com.czu.course_snap_backend.mapper.RegisterMapper;
import com.czu.course_snap_backend.pojo.Login;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.service.RegisterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RegisterServiceImpl implements RegisterService {
    @Autowired
    private RegisterMapper registerMapper;
    @Override
    public Result managerRegister(ManagerInfo managerInfo) {
        if (registerMapper.getManagerInfo(managerInfo.getAccount()) != null) {
            return Result.error("0", "该账号已存在");
        }
        managerInfo.setIdentity(3);
        int i = registerMapper.register(managerInfo);
        if (i == 1) {
            return Result.success(managerInfo);
        } else {
            return Result.error("0", "注册失败");
        }
    }
}
