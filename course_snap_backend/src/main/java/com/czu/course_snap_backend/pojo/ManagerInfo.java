package com.czu.course_snap_backend.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ManagerInfo {
    String name;
    int account;
    String password;
    int identity;
    String token;
    int doing;
    int done;
}
