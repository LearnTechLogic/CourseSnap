package com.czu.course_snap_backend.mapper;

import com.czu.course_snap_backend.pojo.UserInfo;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

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
}
