package com.czu.course_snap_backend.service.impl;

import com.czu.course_snap_backend.mapper.ImageMapper;
import com.czu.course_snap_backend.pojo.Image;
import com.czu.course_snap_backend.pojo.Result;
import com.czu.course_snap_backend.service.ImageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class ImagerServiceImpl implements ImageService {
    private static final Logger log = LoggerFactory.getLogger(ImagerServiceImpl.class);

    @Autowired
    private ImageMapper imageMapper;
    @Value("${imgae.base-url}")
    private String BasePath;
    @Value("${imgae.photo-url}")
    private String PhotoPath;
    @Override
    public Result uploadImage(Image image) {
//        String BasePath = "../image";
        String imageUrl;
        // 文件格式
        String format = image.getImage().getContentType().split("/")[1];
        log.warn(format);
        imageUrl = BasePath + image.getUserAccount() + '-' + image.getImageNum() + "." + format;
        log.warn(imageUrl);
        try {
            // 保存图片
            image.getImage().transferTo(new java.io.File(imageUrl));
            imageUrl = PhotoPath + image.getUserAccount() + '-' + image.getImageNum() + "." + format;
            int update = 0;
            if (image.getImageNum() == 1) {
                update = imageMapper.updateImageUrl1(image.getUserAccount(), imageUrl);
            } else if (image.getImageNum() == 2) {
                update = imageMapper.updateImageUrl2(image.getUserAccount(), imageUrl);
            }
            if (update == 0) {
                return Result.error("0", "图片上传失败");
            }
            return Result.success();
        } catch (Exception e) {
//            return Result.error("0", "图片上传失败");
            log.error("图片上传失败，目标路径：{}", imageUrl, e);
            return Result.error("0", "图片上传失败：" + e.getMessage());
        }
    }
}
