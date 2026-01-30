package com.czu.course_snap_backend.mapper;

import com.czu.course_snap_backend.pojo.ManagerInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface RegisterMapper {
    @Select("select * from manager_info where account = #{account}")
    ManagerInfo getManagerInfo(int account);

    @Update("insert into manager_info(name, account, password, identity) values(#{name}, #{account}, #{password}, #{identity})")
    int register(ManagerInfo managerInfo);
}
