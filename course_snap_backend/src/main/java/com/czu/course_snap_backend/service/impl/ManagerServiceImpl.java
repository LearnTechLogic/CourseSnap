package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ManagerMapper;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.service.ManagerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ManagerServiceImpl implements ManagerService {
    @Autowired
    private ManagerMapper managerMapper;
    @Override
    public Result login(ManagerInfo managerInfo) {
        managerInfo = ma
    }
}
