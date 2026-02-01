package com.czu.course_snap_backend.mapper;

import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.UserInfo;
import org.apache.catalina.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface ProfileMapper {

    @Select("select * from manager_info where account = #{account}")
    ManagerInfo getManagerProfile(int account);

    @Select("select * from user_info order by price desc, id asc ")
    List<UserInfo> getUsersProfile();

    @Select("select user_info.* from allocation_details left join user_info on allocation_details.user_account = user_info.account where allocation_details.manager_account = #{account}")
    List<UserInfo> getUserProfile(int account);

    @Select("select * from user_info where account = #{account}")
    UserInfo getUserProfileById(int account);

    @Update("update user_info set name = #{name}, price = #{price}, state = #{state}, requirement = #{requirement}, qq = #{qq} where account = #{account}")
    int updateUserProfile(UserInfo userInfo);

    @Select("select * from manager_info")
    List<ManagerInfo> getManagerProfileList();

    @Update("delete from user_info where account = #{account}")
    int deleteUserProfile(int account);

    @Update("delete from allocation_details where user_account = #{account}")
    int deleteAllocationDetails(int account);

    @Update("update manager_info set identity = #{identity}, password = #{password} where account = #{account}")
    int updateManagerProfile(ManagerInfo managerInfo);

//    @Update("update allocation_details set manager_account = #{managerAccount}, user_account = #{userAccount}")
   @Insert("insert into allocation_details(manager_account, user_account) values(#{managerAccount}, #{userAccount})")
    int updateAllocation(int managerAccount, int userAccount);

    @Update("update user_info set state = #{state} where account = #{account}")
    int updateState(int account, String state);
}
