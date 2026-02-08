package com.czu.course_snap_backend.controller;

import com.czu.course_snap_backend.pojo.Image;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.service.ImageService;
import lombok.Value;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@RestController
@RequestMapping("/image")
public class ImageController {
    @Autowired
    private ImageService imageService;

    @PostMapping("/post")
    public Result uploadImage(
            @RequestPart("image") MultipartFile file,
            @RequestParam("userAccount") String userAccount,
            @RequestParam("imageNum") String imageNum
    ) {
        if (file == null) {
            return Result.error("0", "图片上传为空");
        }
        return imageService.uploadImage(new Image(Integer.parseInt(userAccount), Integer.parseInt(imageNum), file));
    }
}
