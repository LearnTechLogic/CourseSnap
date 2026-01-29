package com.czu.course_snap_backend.service;

import com.czu.course_snap_backend.pojo.Login;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;

public interface LoginService {
    Result login(Login login);
}
