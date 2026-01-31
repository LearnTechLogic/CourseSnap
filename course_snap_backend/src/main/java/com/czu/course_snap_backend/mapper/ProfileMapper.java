package com.czu.course_snap_backend.mapper;

import com.czu.course_snap_backend.pojo.ManagerInfo;
import com.czu.course_snap_backend.pojo.UserInfo;
import org.apache.catalina.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface ProfileMapper {

    @Select("select * from manager_info where account = #{account}")
    ManagerInfo getManagerProfile(int account);

    @Select("select * from user_info order by price desc, id asc ")
    List<UserInfo> getUserProfile();

    @Select("select * from user_info where account = #{account}")
    UserInfo getUserProfileById(int account);

    @Update("update user_info set name = #{name}, price = #{price}, state = #{state}, requirement = #{requirement}, qq = #{qq} where account = #{account}")
    int updateUserProfile(UserInfo userInfo);
}
