package com.czu.course_snap_backend.service;

import com.czu.course_snap_backend.pojo.AllocationDetails;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;
import org.springframework.web.bind.annotation.RequestParam;

public interface ManagerService {
    Result login(ManagerInfo managerInfo);
    Result register(ManagerInfo managerInfo);
    Result getManagerProfile(int account);
    Result getUserPaidList(int account);
    Result getManagerProfileList(int identity);
    Result getUserProfileByManagerId(int account);
    Result getUserWaitingProfile();
    Result updateAllocation(AllocationDetails allocationDetails);
    Result updateManagerProfile(ManagerInfo managerInfo);
    Result getUserProfile(int identity, int account);
    Result deleteUserProfile(int account, int identity);
    Result getUserProfileById(int account);
    Result updateUserProfile(UserInfo userInfo,int account, int identity);
}
