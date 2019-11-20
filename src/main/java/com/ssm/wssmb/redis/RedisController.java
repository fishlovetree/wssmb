package com.ssm.wssmb.redis;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.data.redis.RedisProperties.Jedis;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ssm.wssmb.model.User;

@Controller
@RequestMapping(value="/redis")
public class RedisController {
	@Autowired
    private RedisTemplate<String, Object> redisTemplate;

	@Autowired
	RedisService redisService;
	
	@RequestMapping(value="/testredis")
	public String Gug() {
		//设置过期时间单位为s
//		redisService.set("k5", "11998",20L);
//		redisService.set("k5", "11998");
//		boolean flag=redisService.exists("k3");
//		System.out.println("存入缓存"+flag);
		
		//切换db
//	    redisService.select(redisTemplate, 3);
		redisService.set("uu:5:fi","www");	
		return "Login/w";
		
	}
	
	//缓存对象集合
	@RequestMapping(value="/obj")
	public String Win() {
		User u1=new User();
		u1.setId(1);
		u1.setUsername("W1");
		User u2=new User();
		u2.setId(2);
		u2.setUsername("W2");
		List<User> list = new ArrayList<User>();
		list.add(u1);
		list.add(u2);
		redisService.set("user", list);
		System.out.println("user:"+redisService.get("user"));
		return "Login/w";
	}
	
}
