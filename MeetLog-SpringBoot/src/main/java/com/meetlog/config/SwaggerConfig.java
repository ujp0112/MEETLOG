package com.meetlog.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Swagger/OpenAPI Configuration
 */
@Configuration
public class SwaggerConfig {

	@Bean
	public OpenAPI meetLogOpenAPI() {
		Server localServer = new Server();
		localServer.setUrl("http://localhost:8080");
		localServer.setDescription("Local Development Server");

		Contact contact = new Contact();
		contact.setName("MeetLog Team");
		contact.setEmail("contact@meetlog.com");

		License license = new License()
				.name("Apache 2.0")
				.url("https://www.apache.org/licenses/LICENSE-2.0.html");

		Info info = new Info()
				.title("MeetLog REST API")
				.version("1.0.0")
				.description("MeetLog 레스토랑 예약 및 리뷰 플랫폼 REST API")
				.contact(contact)
				.license(license);

		return new OpenAPI()
				.info(info)
				.servers(List.of(localServer));
	}
}
