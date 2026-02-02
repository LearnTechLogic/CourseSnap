package com.czu.course_snap_backend.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Image {
    private int userAccount;
    private int imageNum;
    private MultipartFile image;
}
