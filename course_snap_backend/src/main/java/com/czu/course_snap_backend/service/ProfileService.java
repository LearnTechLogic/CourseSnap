package com.czu.course_snap_backend.service;

import com.czu.course_snap_backend.pojo.Result;

public interface ProfileService {
    Result getManagerProfile(int account);
    Result getUserProfile(int identity, int account);
}
