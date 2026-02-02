package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ImageMapper;
import com.czu.course_snap_backend.pojo.Image;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.service.ImageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ImagerServiceImpl implements ImageService {
    private static final Logger log = LoggerFactory.getLogger(ImagerServiceImpl.class);

    @Autowired
    private ImageMapper imageMapper;
    @Override
    public Result uploadImage(Image image) {
        String BasePath = "../image";
        String ImageUrl;
        // 文件格式
        String format = image.getImage().getContentType().split("/")[1];
        log.warn(format);
        ImageUrl = BasePath + image.getUserAccount() + image.getImageNum() + "." + format;
        log.warn(ImageUrl);
        try {
            // 保存图片
            image.getImage().transferTo(new java.io.File(ImageUrl));
            int update = 0;
            if (image.getImageNum() == 1) {
                update = imageMapper.updateImageUrl1(image.getUserAccount(), ImageUrl);
            } else if (image.getImageNum() == 2) {
                update = imageMapper.updateImageUrl2(image.getUserAccount(), ImageUrl);
            }
            if (update == 0) {
                return Result.error("0", "图片上传失败");
            }
            return Result.success();
        } catch (Exception e) {
            return Result.error("0", "图片上传失败");
        }
    }
}
