package com.czu.course_snap_backend.mapper;

import com.czu.course_snap_backend.pojo.UserInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface ProfileMapper {

    @Select("select * from manager_info where account = #{account}")
    UserInfo getUserProfile(int account);
}
