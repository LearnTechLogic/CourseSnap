package com.czu.course_snap_backend.pojo;

import lombok.Data;

@Data
public class Result {
    private String code;
    private String message;
    private Object data;

    public static Result success() {
        Result result = new Result();
        result.code = "1";
        result.message = "success";
        return result;
    }

    public static Result success(Object data) {
        Result result = new Result();
        result.code = "1";
        result.message = "success";
        result.data = data;
        return result;
    }

    public static Result error(String code, String message) {
        Result result = new Result();
        result.code = code;
        result.message = message;
        return result;
    }
}
