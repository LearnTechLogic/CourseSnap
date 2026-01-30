package com.czu.course_snap_backend.service;

import com.czu.course_snap_backend.pojo.Login;
import com.czu.course_snap_backend.pojo.Result;

public interface LoginService {
    Result managerLogin(Login login);
}
