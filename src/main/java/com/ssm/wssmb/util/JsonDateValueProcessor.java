package com.ssm.wssmb.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;


public class JsonDateValueProcessor implements JsonValueProcessor {
	 private String format ="yyyy-MM-dd HH:mm:ss";   
	 private String mFormat ="yyyy-MM-dd";   
	 private String Format ="HH:mm:ss";   
     
	    public Object processArrayValue(Object value, JsonConfig config) {   
	        return process(value);   
	    }   
	  
	    public Object processObjectValue(String key, Object value, JsonConfig config) {   
	        return process(value);   
	    }   
	       
	    private Object process(Object value){ 
	        if(value instanceof Date){ 	        	
	            SimpleDateFormat sdf = new SimpleDateFormat(format,Locale.UK);  
	            if(sdf.format(value).contains("00:00:00")){
	            	 SimpleDateFormat sdf1 = new SimpleDateFormat(mFormat,Locale.UK); 
	            	return  sdf1.format(value);
	            }else if(sdf.format(value).contains("1970-01-01")){
	            	SimpleDateFormat sdf2 = new SimpleDateFormat(Format,Locale.UK);
	            	return sdf2.format(value); 
	            }else{           	
	            }	 return sdf.format(value);             
	        }   
	        return value == null ? "" : value.toString();   
	    } 
}
