package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ManagerMapper;
import com.czu.course_snap_backend.pojo.AllocationDetails;
import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.pojo.UserInfo;
import com.czu.course_snap_backend.service.ManagerService;
import com.czu.course_snap_backend.untils.JwtUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ManagerServiceImpl implements ManagerService {
    private static final Logger log = LoggerFactory.getLogger(ManagerServiceImpl.class);
    @Autowired
    private ManagerMapper managerMapper;
    @Override
    public Result login(ManagerInfo managerInfo) {
        managerInfo = managerMapper.login(managerInfo);
        if (managerInfo == null) {
            return Result.error("0", "账号或密码错误");
        }else {
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put("account", managerInfo.getAccount());
            dataMap.put("identity", managerInfo.getIdentity());
            managerInfo.setToken(JwtUtils.generateJwt(dataMap));
            return Result.success(managerInfo);
        }
    }
    @Override
    public Result register(ManagerInfo managerInfo) {
        if (managerMapper.getManagerInfo(managerInfo.getAccount()) != null) {
            return Result.error("0", "该账号已存在");
        }
        managerInfo.setIdentity(3);
        int i = managerMapper.register(managerInfo);
        if (i == 1) {
            return Result.success(managerInfo);
        } else {
            return Result.error("0", "注册失败");
        }
    }
    @Override
    public Result getManagerProfile(int account) {
        ManagerInfo managerInfo = managerMapper.getManagerInfo(account);
        if (managerInfo == null) {
            return Result.error("0", "该账号不存在");
        }
        return Result.success(managerInfo);
    }
    @Override
    public Result getUserPaidList(int managerId) {
        List<UserInfo> userInfoList = managerMapper.getUserPaidList(managerId);
        return Result.success(userInfoList);
    }
    @Override
    public Result getManagerProfileList(int identity) {
        if (identity != 1) {
            return Result.error("0", "权限不足");
        }
        List<ManagerInfo> managerInfoList = managerMapper.getManagerProfileList();
        for (ManagerInfo managerInfo : managerInfoList) {
            int doing = 0;
            int done = 0;
            List<UserInfo> userInfoList = managerMapper.getUserProfileByManagerId(managerInfo.getAccount());
            if (userInfoList != null && !userInfoList.isEmpty()) {
                for (UserInfo userInfo : userInfoList) {
                    String state = userInfo.getState();
                    if ("已支付".equals(state)) {
                        done ++;
                    } else {
                        doing ++;
                    }
                }
                managerInfo.setDoing(doing);
                managerInfo.setDone(done);
            }
        }
        return Result.success(managerInfoList);
    }
    @Override
    public Result getUserProfileByManagerId(int managerId) {
        return Result.success(managerMapper.getUserProfileByManagerId(managerId));
    }
    @Override
    public Result getUserWaitingProfile() {
        return Result.success(managerMapper.getUserWaitingProfile());
    }
    @Override
    public Result updateAllocation(AllocationDetails allocationDetail) {
        managerMapper.updateAllocation(allocationDetail.getManagerAccount(), allocationDetail.getUserAccount());
        return Result.success();
    }
    @Override
    public Result updateManagerProfile(ManagerInfo managerInfo) {
        int i = managerMapper.updateManagerProfile(managerInfo);
        if (i == 1) {
            return Result.success();
        } else {
            return Result.error("0", "更新失败");
        }
    }
    @Override
    public Result getUserProfile(int identity, int account) {
        List<UserInfo> userInfoList;
        if (identity == 1) {
            userInfoList = managerMapper.getUserProfile();
            return Result.success(userInfoList);
        } else if (identity == 2) {
            userInfoList = managerMapper.getUserProfilesById(account);
            return Result.success(userInfoList);
        } else {
            return Result.error("0", "权限不足");
        }
    }
    @Override
    public Result deleteUserProfile(int account, int identity) {
        if (identity == 1) {
            int i = managerMapper.deleteUserProfile(account);
            if (i == 1) {
                return Result.success();
            } else {
                return Result.error("0", "删除失败");
            }
        } else {
            int i = managerMapper.deleteUserProfileState(account);
            if (i == 1) {
                return Result.success();
            }
            return Result.error("0", "权限不足");
        }
    }
    @Override
    public Result getUserProfileById(int account) {
        return Result.success(managerMapper.getUserProfileById(account));
    }
    @Override
    public Result updateUserProfile(UserInfo userInfo,int managerId, int identity) {
        if (identity == 1) {
            int i = managerMapper.updateUserProfile(userInfo);
            if (i == 1) {
                return Result.success();
            }
            return Result.error("0", "更新失败");
        }
        if (identity == 2) {
            if (managerId != userInfo.getManagerId()) {
                return Result.error("0", "权限不足");
            }
            if (userInfo.getState().equals("已支付")) {
                return Result.error("0", "权限不足");
            }
            int i = managerMapper.updateUserProfile(userInfo);
            if (i == 1) {
                return Result.success();
            }
        }
        return Result.error("0", "更新失败");
    }
}
