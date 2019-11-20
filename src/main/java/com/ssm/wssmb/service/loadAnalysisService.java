package com.ssm.wssmb.service;

public interface loadAnalysisService {
	
	public String loadData(Integer id,String startdate,String enddate, int startindex, int endindex)throws Exception;
	
	public String powerAnalysis(Integer id,String startdate,String enddate)throws Exception;

}
