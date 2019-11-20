package com.ssm.wssmb.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ssm.wssmb.model.BusMessagepushrecord;
import com.ssm.wssmb.model.User;
import com.ssm.wssmb.service.BusMessageService;

@Controller
@RequestMapping(value = "/message")
public class MessageController {

	@Resource
	private BusMessageService messageService;

	/**
	 * @Description 消息推送列表
	 * @param re
	 * @return
	 * @throws Exception
	 * @Time  rcd
	 * @Author
	 * @type 前端方法
	 */
	@RequestMapping(value = "/messageDataGrid", method = RequestMethod.POST, produces = "application/json;charset=UTF-8;")
	public @ResponseBody String messageDataGrid(HttpServletRequest re, Integer id, Integer type, String msgtypecode,
			String startTime, String endTime, String address, String name, int page, int rows) throws Exception {
		User user = (User) re.getSession(true).getAttribute("wssmb_front_user");

		return messageService.queryMessage(id, type, user.getOrganizationid(), msgtypecode, startTime, endTime, address,
				name, (page - 1) * rows + 1, page * rows);
	}

}
