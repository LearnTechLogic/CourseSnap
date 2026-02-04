package com.czu.course_snap_backend.service;

import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;

public interface UserService {
    Result login(int account, String password);

    Result register(UserInfo userInfo);

    Result getUserInfo(int account);

    Result updateUserInfo(UserInfo userInfo);

    Result applyUserInfo(UserInfo userInfo);
}
