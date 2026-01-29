package com.czu.course_snap_backend.untils;

import java.util.Map;

public class ThreadLocalUtil {
    private static final ThreadLocal<Map<String, Object>> threadLocal = new ThreadLocal<>();

    public static void set(Map<String, Object> map) {
        threadLocal.set(map);
    }

    public static Map<String, Object> get() {
        return threadLocal.get();
    }

    public static void remove() {
        threadLocal.remove();
    }
}
