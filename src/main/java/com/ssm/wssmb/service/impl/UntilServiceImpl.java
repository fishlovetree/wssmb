package com.ssm.wssmb.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JsonConfig;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssm.wssmb.model.Menu;
import com.ssm.wssmb.service.UntilService;
import com.ssm.wssmb.util.FloatJsonValueProcessor;
import com.ssm.wssmb.util.JsonDateValueProcessor;


@Service
public class UntilServiceImpl implements UntilService{
	
	/********************************前端页面分页json代码****************************************/		
	/**
	 *获取分页的json数据 
	 * **/
	@Override
	public String getDataPager(List<?> list, int page,int rows) throws Exception {
		//存放数据的集合
		List<Object> mList=new ArrayList<Object>();
		if(null==list || list.size()<=0) return "{\"total\":"+0+",\"rows\":"+0+"}"; 
		//总条数
		int count =list.size();
		//开始
		int start=(page-1)*rows;
		//结束
		int end=(page-1)*rows+rows;
		if(end<=list.size()){
			for(int i=start;i<end;i++){
				mList.add(list.get(i));
			}
		}else{
			for(int i=start;i<list.size();i++){
				mList.add(list.get(i));
			}
		}
		/*String json = JSONArray.fromObject(mList).toString();
		json="{\"total\":"+count+",\"rows\":"+json+"}";*/    	
        JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class , new JsonDateValueProcessor());
	    jsonConfig.registerJsonValueProcessor(Float.class, new FloatJsonValueProcessor()); 
	    
	    JSONArray jo = JSONArray.fromObject(mList, jsonConfig);
	    String json = "{\"total\":"+count+",\"rows\":"+jo.toString()+"}"; 
	    return json;
	}
	
	@Override
	public String getGsonDataPager(List<?> list, int page,int rows) throws Exception {
		//存放数据的集合
		List<Object> mList=new ArrayList<Object>();
		if(null==list || list.size()<=0) return "{\"total\":"+0+",\"rows\":"+0+"}"; 
		//总条数
		int count =list.size();
		//开始
		int start=(page-1)*rows;
		//结束
		int end=(page-1)*rows+rows;
		if(end<=list.size()){
			for(int i=start;i<end;i++){
				mList.add(list.get(i));
			}
		}else{
			for(int i=start;i<list.size();i++){
				mList.add(list.get(i));
			}
		}
		/*String json = JSONArray.fromObject(mList).toString();
		json="{\"total\":"+count+",\"rows\":"+json+"}";*/    
		//没有用到？
        JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class , new JsonDateValueProcessor());
	    jsonConfig.registerJsonValueProcessor(Float.class, new FloatJsonValueProcessor()); 
	    
	    Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		String jo = gson.toJson(mList);
	    String json = "{\"total\":"+count+",\"rows\":"+jo.toString()+"}"; 
	    return json;
	}
	
	/**
	 *获取分页的json数据 
	 * **/
	@Override
	public String getDataPager(List<?> list, int page,int rows, Boolean flag,String footer) throws Exception {
		//存放数据的集合
		List<Object> mList=new ArrayList<Object>();
		//总条数
		int count =list.size();
		if(flag){
			for(int i=0;i<list.size();i++){
				mList.add(list.get(i));
			}
		}
		else{
			//开始
			int start=(page-1)*rows;
			//结束
			int end=(page-1)*rows+rows;
			if(end<=list.size()){
				for(int i=start;i<end;i++){
					mList.add(list.get(i));
				}
			}else{
				for(int i=start;i<list.size();i++){
					mList.add(list.get(i));
				}
			}
		}
		/*String json = JSONArray.fromObject(mList).toString();
		json="{\"total\":"+count+",\"rows\":"+json+"}";*/    	
        JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class , new JsonDateValueProcessor());
	    jsonConfig.registerJsonValueProcessor(Float.class, new FloatJsonValueProcessor()); 
	    
	    JSONArray jo = JSONArray.fromObject(mList, jsonConfig);
	    String json = "{\"total\":"+count+",\"rows\":"+jo.toString()+footer+"}"; 
	    return json;
	}
	
	/**
	 *获取分页的json数据 
	 * **/
	@Override
	public String getDataPager(List<?> list, int count) throws Exception {
		if(null==list || list.size()<=0) return "{\"total\":"+0+",\"rows\":"+0+"}"; 
		//总条数
		count = count == 0 ? list.size() : count;	
        JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class , new JsonDateValueProcessor());
	    jsonConfig.registerJsonValueProcessor(Float.class, new FloatJsonValueProcessor()); 
	    
	    JSONArray jo = JSONArray.fromObject(list, jsonConfig);
	    String json = "{\"total\":"+count+",\"rows\":"+jo.toString()+"}"; 
	    return json;
	}
	
	/** 
	 * �ݹ����ò˵��� ��δ����Ȩ�ޣ�
	 * @param list 
	 * @param fid 
	 * @return 
	 */  
	public List<Map<String, Object>> createTreeGrid(List<Menu> list, int pid)throws Exception {  
	    List<Map<String, Object>> childList = new ArrayList<Map<String, Object>>();  
	    for (int j = 0; j < list.size(); j++) {  
	        Map<String, Object> map = null;  

	        Menu menu = (Menu) list.get(j);
			//�ж�fid�Ƿ�Ϊ��ID
		   	if (menu.getSuperid()==pid) {  
		   		map = new HashMap<String, Object>(); 

		   		map.put("id", menu.getId());         //id 	       
	            map.put("pid", menu.getSuperid()); //��id  
	            map.put("text", menu.getMenuname());     //��ɫ��  
	            map.put("entext", menu.getMenuenname());//Ӣ������
	            String url=menu.getMenuurl();
	            if(null==url || url.trim().equals("")){
	            	map.put("url", "");//�������/��Ӧ������
	            }else{
	            	map.put("url", url);//�������/��Ӧ������
	            }
	            map.put("menuorder", menu.getMenuorder());//�˵�����
	            map.put("iconCls", menu.getMenuicon());//�˵�ͼ��
	            map.put("status", menu.getStatus());//״̬
	            map.put("state", "closed");
		   	}

	        if (map != null)  
	            childList.add(map);  
	    }  
	    return childList;  
	}
}
