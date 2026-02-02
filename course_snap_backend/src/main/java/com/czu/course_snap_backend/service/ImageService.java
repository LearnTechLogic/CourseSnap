package com.czu.course_snap_backend.service;

import com.czu.course_snap_backend.pojo.Image;
import com.czu.course_snap_backend.pojo.Result;

public interface ImageService {
    Result uploadImage(Image image);
}
