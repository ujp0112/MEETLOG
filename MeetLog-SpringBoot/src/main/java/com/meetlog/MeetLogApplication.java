package com.meetlog;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**
 * MeetLog Spring Boot Application
 *
 * @author MeetLog Team
 * @version 1.0.0
 */
@SpringBootApplication
@MapperScan("com.meetlog.repository")
@EnableAspectJAutoProxy
public class MeetLogApplication {

	public static void main(String[] args) {
		SpringApplication.run(MeetLogApplication.class, args);
	}

}
