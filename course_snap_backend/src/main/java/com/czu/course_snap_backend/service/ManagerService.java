package com.czu.course_snap_backend.service;

import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.Result;

public interface ManagerService {
    Result login(ManagerInfo managerInfo);
}
