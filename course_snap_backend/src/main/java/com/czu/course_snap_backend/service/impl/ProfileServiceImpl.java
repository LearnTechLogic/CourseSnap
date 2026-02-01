package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ProfileMapper;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.UserInfo;
import com.czu.course_snap_backend.service.ProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Iterator;
import java.util.List;

@Service
public class ProfileServiceImpl implements ProfileService {
    @Autowired
    private ProfileMapper profileMapper;
    @Override
    public Result getManagerProfile(int account) {
        ManagerInfo managerInfo = profileMapper.getManagerProfile(account);
        if (managerInfo == null) {
            return Result.error("0", "用户不存在");
        }
        return Result.success(managerInfo);
    }

    @Override
    public Result getManagerProfileList(int identity) {
        if (identity == 1) {
            List<ManagerInfo> managerInfos = profileMapper.getManagerProfileList();
            List<UserInfo> userInfos;
            int doing = 0;
            int done = 0;
            if (managerInfos == null) {
                return Result.error("0", "用户不存在");
            }
            for (ManagerInfo managerInfo : managerInfos) {
                userInfos = profileMapper.getUserProfile(managerInfo.getAccount());
                for (UserInfo userInfo : userInfos) {
                    if ("已支付".equals(userInfo.getState())) {
                        done ++;
                    } else {
                        doing ++;
                    }
                }
                managerInfo.setDoing(doing);
                managerInfo.setDone(done);
                doing = 0;
                done = 0;
            }
            return Result.success(managerInfos);
        } else {
            return Result.error("0", "权限不足");
        }
    }

    @Override
    public Result getUserProfile(int identity, int account) {
        if (identity == 1) {
            List<UserInfo> userInfo = profileMapper.getUsersProfile();
            if (userInfo == null) {
                return Result.error("0", "用户不存在");
            }
            return Result.success(userInfo);
        } else if (identity == 2) {
            List<UserInfo> userInfo = profileMapper.getUserProfile(account);
            Iterator<UserInfo> iterator = userInfo.iterator();
            while (iterator.hasNext()) {
                UserInfo userInfo1 = iterator.next();
                // 判断状态等于 "name" 时移除
                if ("已支付".equals(userInfo1.getState())) { // 常量放前面，避免空指针
                    iterator.remove(); // 使用迭代器的 remove 方法，安全移除
                }
            }
            if (userInfo == null) {
                return Result.error("0", "暂无信息");
            }
            return Result.success(userInfo);
        } else {
            return Result.error("0", "权限不足");
        }
    }

    @Override
    public Result getUserWaitingProfile() {
        List<UserInfo> userInfo = profileMapper.getUsersProfile();
        // 判断状态等于 "name" 时移除
        // 常量放前面，避免空指针
        // 使用迭代器的 remove 方法，安全移除
        userInfo.removeIf(userInfo1 -> !"等待".equals(userInfo1.getState()));
        return Result.success(userInfo);
    }
    @Override
    public Result getUserProfile(int account) {
        UserInfo userInfo = profileMapper.getUserProfileById(account);
        if (userInfo == null) {
            return Result.error("0", "用户不存在");
        }
        return Result.success(userInfo);
    }

    @Override
    public Result updateUserProfile(UserInfo userInfo) {
        int update = profileMapper.updateUserProfile(userInfo);
        if (update == 0) {
            return Result.error("0", "更新失败");
        }
        return Result.success();
    }

    @Override
    public Result deleteUserProfile(int accountInt, int identity) {
        if (identity == 1) {
            UserInfo userInfo = profileMapper.getUserProfileById(accountInt);
            int delete = profileMapper.deleteUserProfile(accountInt);
            if (delete == 0) {
                return Result.error("0", "删除失败");
            }
            return Result.success();
        } else if (identity == 2) {
            UserInfo userInfo = profileMapper.getUserProfileById(accountInt);
            int delete = profileMapper.deleteAllocationDetails(accountInt);
            if (delete == 0) {
                return Result.error("0", "删除失败");
            }
            return Result.success();
        } else {
            return Result.error("0", "权限不足");
        }
    }

    @Override
    public Result updateManagerProfile(ManagerInfo managerInfo) {
        int update = profileMapper.updateManagerProfile(managerInfo);
        if (update == 0) {
            return Result.error("0", "更新失败");
        }
        return Result.success();
    }

    @Override
    public Result updateAllocation(int managerAccount, int userAccount) {
        int updateAllocation = profileMapper.updateAllocation(managerAccount, userAccount);
        int updateState = profileMapper.updateState(userAccount, "进行中");
        if (updateAllocation == 0 || updateState == 0) {
            return Result.error("0", "更新失败");
        }
        return Result.success();
    }

    @Override
    public Result getUserPaid(int account) {
        List<UserInfo> userInfo = profileMapper.getUserProfile(account);
        userInfo.removeIf(userInfo1 -> !"已支付".equals(userInfo1.getState()));
        return Result.success(userInfo);
    }
}
