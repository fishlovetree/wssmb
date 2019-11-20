package com.ssm.wssmb.service.impl;

import javax.annotation.Resource;

/*import org.hibernate.Hibernate;
import org.hibernate.Session;*/
import org.springframework.stereotype.Service;

import com.ssm.wssmb.mapper.BusVideomonitorMapper;
import com.ssm.wssmb.mapper.CommonTreeMapper;
import com.ssm.wssmb.mapper.ConstantDetailMapper;
import com.ssm.wssmb.mapper.OrgAndCustomerMapper;
import com.ssm.wssmb.mapper.RegionMapper;
import com.ssm.wssmb.service.CommonTreeService;
import com.ssm.wssmb.service.VideoMonitorService;
import com.ssm.wssmb.util.EventLogAspect;

@Service
public class VideoMonitorServiceImpl implements VideoMonitorService {
	@Resource
	private ConstantDetailMapper constantDetailMapper;

	@Resource
	private CommonTreeService commonTreeService;

	@Resource
	BusVideomonitorMapper VideoMapper;

	@Resource
	OrgAndCustomerMapper orgAndCustomerMapper;

	@Resource
	private RegionMapper regionMapper;

	@Resource
	private BusVideomonitorMapper busVideomonitorMapper;

	@Resource
	private EventLogAspect log;

	@Resource
	private CommonTreeMapper commonTreeMapper;

	// @Override
	// public String packetRequest(Integer commendtype, Integer minitorid)
	// throws Exception {
	// TaskInfo taskInfo = new TaskInfo();
	// taskInfo.msgType = ENUM_MSG_TYPE.msg_Request;
	// taskInfo.commandType = ENUM_COMMAND_TYPE.videorequest;
	// taskInfo.priority = 0;
	// taskInfo.communicationChannel = 0;
	// String taskinfoXML = PacketXML.Packet_TaskInfo(taskInfo);
	//
	// // 发送数据
	// BusVideomonitor video = busVideomonitorMapper.selectByVideoId(minitorid);
	// VideoCommData request = getVideoCommDataByCamere(video);
	//
	// if (commendtype == 1) {
	// request.videoCommand = VideoCommand.OPEN;// 打开
	// } else if (commendtype == 2) {
	// request.videoCommand = VideoCommand.Close;// 关闭
	// }
	//
	// String dataXML = PacketXML.Packet_VideoCommData(request);
	//
	// /*
	// * String content = "摄像头名称：" + video.getVideomonitorname() + "，组织机构编码："
	// * + video.getOrganizationcode() + "，摄像头编码：" + request.cameraID +
	// * "，播放类型：" + request.videoCommand; log.addLog("", "视频实时监控请求", content,
	// * 5);
	// */
	//
	// return taskinfoXML + dataXML;
	// }
}
