package com.ssm.wssmb.util;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @Description:自定义注解，用于记录系统操作的类型，描述等
 * @Author lmn
 * @Time: 2018年1月5日
 */
@Target(value =ElementType.METHOD)
@Retention(value = RetentionPolicy.RUNTIME)
@Documented
public @interface Operation {

    /**
     * @Description描述操作类型   日志类型 增 -0;删-1;改-2；启用-3；停用-4；请求-5；响应-6；设置-7；
     */
	int type();

    /**
     * @Description描述操作意义   比如添加操作员，修改菜单等
     */
    String desc() default ""; 

    /**
     * @Description描述操作方法的参数意义 数组长度需与参数长度一致,否则会参数与描述不一致的情况
     */
    String[] arguDesc() default {};
}