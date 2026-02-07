package com.czu.course_snap_backend.mapper;

import com.czu.course_snap_backend.pojo.UserInfo;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface UserMapper {
    @Select("select * from user_info where account=#{account} and password=#{password}")
    UserInfo login(int account, String password);

    @Select("select * from user_info where account=#{account}")
    UserInfo getUserInfo(int account);

//    @Select("insert into user_info values(#{account},#{password})")
//    int register(UserInfo userInfo);

    @Insert("insert into user_info (account, password, state) values(#{account},#{password},#{state})")
    int register(int account, String password, String state);

    @Update("update user_info set name=#{password},password=#{password},price=#{price},requirement=#{requirement},qq=#{qq} where account=#{account}")
    int updateUserInfo(int account, String name, String password, int price, String requirement, String qq);

    @Insert("update user_info set state=#{state} where account=#{account}")
    int applyUserInfo(int account, String state);

    @Select("select * from user_info order by price desc, id asc ")
    List<UserInfo> getWaitList();
}
