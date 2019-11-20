package com.ssm.wssmb.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;


/**
 * @author rcd
 *
 */
@Configuration
public class MessageSourceConfig {
	/**
	 * @return resourceBundleMessageSource
	 * @throws Exception
	 */
	@Bean(name = "messageSource")
	public ResourceBundleMessageSource getMessageSource() throws Exception {
		ResourceBundleMessageSource resourceBundleMessageSource = new ResourceBundleMessageSource();
		resourceBundleMessageSource.setDefaultEncoding("UTF-8");
		resourceBundleMessageSource.setBasenames("i18n/messages");
		return resourceBundleMessageSource;
	}
}
