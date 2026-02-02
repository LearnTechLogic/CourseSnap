package com.czu.course_snap_backend.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ImageMapper {
    @Update("update user_info set image1 = #{imageUrl} where account = #{userAccount}")
    int updateImageUrl1(int userAccount, String imageUrl);

    @Update("update user_info set image2 = #{imageUrl} where account = #{userAccount}")
    int updateImageUrl2(int userAccount, String imageUrl);
}
