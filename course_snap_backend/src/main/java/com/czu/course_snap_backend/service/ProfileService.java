package com.czu.course_snap_backend.service;

import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;

public interface ProfileService {
    Result getManagerProfile(int account);
    Result getUserProfile(int identity, int account);
    Result getUserProfile(int account);
    Result updateUserProfile(UserInfo userInfo);
    Result getManagerProfileList(int identity);
    Result deleteUserProfile(int accountInt, int identity);
    Result updateManagerProfile(ManagerInfo managerInfo);
    Result getUserWaitingProfile();

    Result updateAllocation(int managerAccount, int userId);

    Result getUserPaid(int account);
}
