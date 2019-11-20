package com.ssm.wssmb.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/videoMonitor")
public class VideoMonitorController {

	/**
	 * @Description 发送数据组帧
	 * @param type
	 *            确认请求和数据请求
	 * @return
	 * @throws Exception
	 * @Time 2019年9月24日
	 * @Author Eric
	 */
	@RequestMapping(value = "/packetRequest", method = RequestMethod.POST, produces = "text/html;charset=UTF-8;")
	public @ResponseBody String PacketRequest(HttpServletRequest re, Integer commendtype, Integer minitorid)
			throws Exception {
		return null;
		// return videomonitorservice.packetRequest(commendtype, minitorid);
	}

}
