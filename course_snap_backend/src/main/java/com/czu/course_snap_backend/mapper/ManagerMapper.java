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
}
