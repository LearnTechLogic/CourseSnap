package com.czu.course_snap_backend.mapper;

import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.UserInfo;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ManagerMapper {
    @Select("select * from manager_info where account=#{account} and password=#{password}")
    ManagerInfo login(ManagerInfo managerInfo);

    @Insert("insert into manager_info(name,account,password,identity) values(#{name},#{account},#{password},#{identity})")
    int register(ManagerInfo managerInfo);

    @Select("select * from manager_info where account=#{account}")
    ManagerInfo getManagerInfo(int account);

    @Select("select name, account, price from user_info where manager_id=#{managerId} and state='已支付'")
    List<UserInfo> getUserPaidList(int managerId);

    @Select("select * from manager_info")
    List<ManagerInfo> getManagerProfileList();

    @Select("select name, account, price, state from user_info where manager_id= #{managerId}")
    List<UserInfo> getUserProfileByManagerId(int managerId);

    @Select("select name, account, price from user_info where state='等待'")
    List<UserInfo> getUserWaitingProfile();

    @Insert("update user_info set manager_id=#{managerAccount}, state='进行中' where account=#{userAccount}")
    void updateAllocation(int managerAccount, int userAccount);

    @Insert("update manager_info set name=#{name}, password=#{password}, identity=#{identity} where account=#{account}")
    int updateManagerProfile(ManagerInfo managerInfo);

    @Select("select * from user_info order by price desc ,id asc ")
    List<UserInfo> getUserProfile();

    @Select("select * from user_info where account= #{account}")
    List<UserInfo> getUserProfilesById(int account);

    @Insert("delete from user_info where account= #{account}")
    int deleteUserProfile(int account);

    @Insert("update user_info set state='拒绝' where account= #{account}")
    int deleteUserProfileState(int account);

    @Select("select * from user_info where account= #{account}")
    UserInfo getUserProfileById(int account);

    @Insert("update user_info set name= #{name}, price= #{price}, state= #{state} where account= #{account}")
    int updateUserProfile(UserInfo userInfo);
}
