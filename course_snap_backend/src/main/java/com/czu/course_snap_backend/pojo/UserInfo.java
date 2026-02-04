package com.czu.course_snap_backend.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserInfo {
    int account;
    String name;
    String password;
    int price;
    String state;
    String requirement;
    String qq;
    String image1;
    String image2;
    String token;
}
