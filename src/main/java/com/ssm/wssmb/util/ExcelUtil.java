package com.ssm.wssmb.util;

import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.beans.PropertyDescriptor;
import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.NumberToTextConverter;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFPicture;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelUtil {
	
	  /** 
     * 根据excel单元格类型获取excel单元格值 
     * @param cell 
     * @return 
     */  
	public static String getCellValue(Cell cell) {  
        String cellvalue = "";  
        if (cell != null) {  
            // 判断当前Cell的Type  
            switch (cell.getCellType()) {  
	            // 如果当前Cell的Type为NUMERIC  
	            case HSSFCell.CELL_TYPE_NUMERIC: {  
	                short format = cell.getCellStyle().getDataFormat();  
	                if(format == 14 || format == 31 || format == 57 || format == 58){   //excel中的时间格式  
	                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");    
	                    double value = cell.getNumericCellValue();    
	                    Date date = DateUtil.getJavaDate(value);    
	                    cellvalue = sdf.format(date);    
	                }  
	                // 判断当前的cell是否为Date  
	                else if (HSSFDateUtil.isCellDateFormatted(cell)) {  //先注释日期类型的转换，在实际测试中发现HSSFDateUtil.isCellDateFormatted(cell)只识别2014/02/02这种格式。  
	                    // 如果是Date类型则，取得该Cell的Date值           // 对2014-02-02格式识别不出是日期格式  
	                    Date date = cell.getDateCellValue();  
	                    DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");  
	                    cellvalue= formater.format(date);  
	                } else { // 如果是纯数字  
	                    // 取得当前Cell的数值  
	                    cellvalue = NumberToTextConverter.toText(cell.getNumericCellValue());   
	                      
	                }  
	                break;  
	            }  
	            // 如果当前Cell的Type为STRIN  
	            case HSSFCell.CELL_TYPE_STRING:  
	                // 取得当前的Cell字符串  
	                cellvalue = cell.getStringCellValue().replaceAll("'", "''");  
	                break;  
	            case  HSSFCell.CELL_TYPE_BLANK:  
	                cellvalue = null;  
	                break;  
	            // 默认的Cell值  
	            default:{  
	                cellvalue = " ";  
	            }  
            }  
        } else {  
            cellvalue = "";  
        }  
        return cellvalue;  
    }
   
	  
    /** 
     * 导入Excel表结束 
     * 导出Excel表开始 
     * @param sheetName 工作簿名称 
     * @param clazz  数据源model类型 
     * @param objs   excel标题列以及对应model字段名 
     * @param map  标题列行数以及cell字体样式 
     */  
    public static XSSFWorkbook createExcelFile(Class clazz, List objs, Map<Integer, List<ExcelBean>> map, String sheetName) throws Exception {  
    	// 创建新的Excel工作簿
		XSSFWorkbook workbook = new XSSFWorkbook();
		// 在Excel工作簿中建一工作表，其名为缺省值, 也可以指定Sheet名称
		XSSFSheet sheet = workbook.createSheet(sheetName);
		// sheet.setDefaultRowHeight((short)500);
		// 以下为excel的字体样式以及excel的标题与内容的创建，下面会具体分析;
		createFont(workbook); // 字体样式
		createTableHeader(sheet, map); // 创建标题（头）
		createTableRows(workbook, sheet, map, objs, clazz); // 创建内容
		return workbook;
    } 
    
    private static XSSFCellStyle fontStyle;  
    private static XSSFCellStyle fontStyle2; 
    
    public static void createFont(XSSFWorkbook workbook) {  
        // 表头  
        fontStyle = workbook.createCellStyle();  
        XSSFFont font1 = workbook.createFont();  
        font1.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);  
        font1.setFontName("黑体");  
        font1.setFontHeightInPoints((short) 14);// 设置字体大小  
        fontStyle.setFont(font1);  
        fontStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN); // 下边框  
        fontStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);// 左边框  
        fontStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);// 上边框  
        fontStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);// 右边框  
        fontStyle.setAlignment(XSSFCellStyle.ALIGN_CENTER); // 居中  
        // 内容  
        fontStyle2=workbook.createCellStyle();  
        XSSFFont font2 = workbook.createFont();  
        font2.setFontName("宋体");  
        font2.setFontHeightInPoints((short) 10);// 设置字体大小  
        fontStyle2.setFont(font2);  
        fontStyle2.setBorderBottom(XSSFCellStyle.BORDER_THIN); // 下边框  
        fontStyle2.setBorderLeft(XSSFCellStyle.BORDER_THIN);// 左边框  
        fontStyle2.setBorderTop(XSSFCellStyle.BORDER_THIN);// 上边框  
        fontStyle2.setBorderRight(XSSFCellStyle.BORDER_THIN);// 右边框  
        fontStyle2.setAlignment(XSSFCellStyle.ALIGN_CENTER); // 居中  
        //设置CELL格式为文本格式 
        XSSFDataFormat format = workbook.createDataFormat();  
        fontStyle2.setDataFormat(format.getFormat("@"));  
    }  
    /** 
     * 根据ExcelMapping 生成列头（多行列头） 
     * 
     * @param sheet 工作簿 
     * @param map 每行每个单元格对应的列头信息 
     */  
    public static final void createTableHeader(XSSFSheet sheet, Map<Integer, List<ExcelBean>> map) {  
        int startIndex=0;//cell起始位置  
        int endIndex=0;//cell终止位置  
        for (Map.Entry<Integer, List<ExcelBean>> entry : map.entrySet()) {  
            XSSFRow row = sheet.createRow(entry.getKey());  
            List<ExcelBean> excels = entry.getValue();  
            for (int x = 0; x < excels.size(); x++) {  
                //合并单元格  
                if(excels.get(x).getCols()>1){  
                    if(x==0){  
                        endIndex+=excels.get(x).getCols()-1;  
                        CellRangeAddress range=new CellRangeAddress(0,0,startIndex,endIndex);  
                        sheet.addMergedRegion(range);  
                        startIndex+=excels.get(x).getCols();  
                    }else{  
                        endIndex+=excels.get(x).getCols();  
                        CellRangeAddress range=new CellRangeAddress(0,0,startIndex,endIndex);  
                        sheet.addMergedRegion(range);  
                        startIndex+=excels.get(x).getCols();  
                    }  
                    XSSFCell cell = row.createCell(startIndex-excels.get(x).getCols());  
                    cell.setCellValue(excels.get(x).getHeadTextName());// 设置内容  
                    if (excels.get(x).getCellStyle() != null) {  
                        cell.setCellStyle(excels.get(x).getCellStyle());// 设置格式  
                    }  
                    cell.setCellStyle(fontStyle); 
                }else{  
                    XSSFCell cell = row.createCell(x);  
                    cell.setCellValue(excels.get(x).getHeadTextName());// 设置内容  
                    if (excels.get(x).getCellStyle() != null) {  
                        cell.setCellStyle(excels.get(x).getCellStyle());// 设置格式  
                    }  
                    cell.setCellStyle(fontStyle);      
                }  
            }  
        }  
    }
    
    public static void createTableRows(XSSFWorkbook workbook,XSSFSheet sheet, Map<Integer, List<ExcelBean>> map, List objs, Class clazz)  
            throws Exception {  
        int rowindex = map.size();  
        int maxKey = 0;  
        List<ExcelBean> ems = new ArrayList<>();  
        for (Map.Entry<Integer, List<ExcelBean>> entry : map.entrySet()) {  
            if (entry.getKey() > maxKey) {  
                maxKey = entry.getKey();  
            }  
        }  
        ems = map.get(maxKey);  
        List<Integer> widths = new ArrayList<Integer>(ems.size());  
        //先设好图片列宽，避免图片失真
        sheet.setColumnWidth(20, 8400);//设备图片
        sheet.setColumnWidth(21, 8400);//安装图片
        for (Object obj : objs) {  
            XSSFRow row = sheet.createRow(rowindex);
            for (int i = 0; i < ems.size(); i++) {  
                ExcelBean em = (ExcelBean) ems.get(i);  
                // 获得get方法  
                PropertyDescriptor pd = new PropertyDescriptor(em.getPropertyName(), clazz);  
                Method getMethod = pd.getReadMethod();  
                Object rtn = getMethod.invoke(obj);  
                String value = "";  
               
                // 如果是日期类型进行转换  
                if (rtn != null) {  
                    if (rtn instanceof Date) { 
                    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                		value = formatter.format((Date)rtn);
                    }else if(rtn instanceof BigDecimal){  
                        NumberFormat nf = new DecimalFormat("#,##0.00");  
                        value=nf.format((BigDecimal)rtn).toString();  
                    } else if((rtn instanceof Integer) && (Integer.valueOf(rtn.toString())<0 )){  
                        value="--";  
                    } else if(rtn instanceof byte[]){//图片
                    	row.setHeightInPoints(175);//设置行高(像素数)
                    	byte[] indata = (byte[])rtn ;
                    	BufferedInputStream in =null; 
                		InputStream inStream = new ByteArrayInputStream(indata);
                		long nLen = indata.length; 
                		int nSize = (int) nLen; 
                		byte[] data = new byte[nSize]; 
                		inStream.read(data); 
                		data=ChangeImgSize(data,230,230); //将读取数据流转换成图片，并设置大小 
                		inStream = new ByteArrayInputStream(data); 
                		try { 
	                		in = new BufferedInputStream(inStream,1024); 
	                	} catch (Exception e1) { 
	                		e1.printStackTrace(); 
                		} 
                		int pictureIdx =workbook.addPicture(in, workbook.PICTURE_TYPE_JPEG);//向excel中插入图片 
                		XSSFDrawing drawing = sheet.createDrawingPatriarch(); //创建绘图对象 
                		// XSSFClientAnchor的参数说明： 
                		// 参数 说明 
                		// dx1 第1个单元格中x轴的偏移量 
                		// dy1 第1个单元格中y轴的偏移量 
                		// dx2 第2个单元格中x轴的偏移量 
                		// dy2 第2个单元格中y轴的偏移量 
                		// col1 第1个单元格的列号 
                		// row1 第1个单元格的行号 
                		// col2 第2个单元格的列号 
                		// row2 第2个单元格的行号 
                		//XSSFClientAnchor anchor= new XSSFClientAnchor(1, 1, 1, 1,(short) colNum, row1, (short) colNum+1, row2);
                		XSSFClientAnchor anchor = null;
                		if(getMethod.getName().equals("getPicture1")){
                			anchor= new XSSFClientAnchor(1, 1, 255, 255,(short) 20, rowindex, (short) 21, rowindex);//定位图片的位置 
                		}else if(getMethod.getName().equals("getPicture2")){
                			anchor= new XSSFClientAnchor(1, 1, 255, 255,(short) 21, rowindex, (short) 22, rowindex);//定位图片的位置 
                		}
                		XSSFPicture pict = drawing.createPicture(anchor, pictureIdx); 
                		pict.resize();
                    }else {  
                        value = rtn.toString();  
                    }  
                }  
                XSSFCell cell = row.createCell(i);  
                cell.setCellValue(value);  
                cell.setCellType(XSSFCell.CELL_TYPE_STRING);  
                cell.setCellStyle(fontStyle2); 
                // 获得最大列宽  
                int width = value.getBytes().length * 300;  
                // 还未设置，设置当前  
                if (widths.size() <= i) {  
                    widths.add(width);  
                    continue;  
                }  
                // 比原来大，更新数据  
                if (width > widths.get(i)) {  
                    widths.set(i, width);  
                }  
            }  
            rowindex++;  
        }  
        // 设置列宽  
        for (int index = 0; index < widths.size()-2; index++) { //除去最后两列 
            Integer width = widths.get(index);  
            width = width < 2500 ? 2500 : width + 300;  
            width = width > 10000 ? 10000 + 300 : width + 300;  
            sheet.setColumnWidth(index, width);
        }
        
 
    }
    
    /**
     * 图片转换，将读取图片放大或缩小(等比例压缩)
     * 
     * */
    public static  byte[] ChangeImgSize(byte[] data, int resize_width, int resize_height){     
        byte[] newdata = null;     
        try{      
                BufferedImage bi = ImageIO.read(new ByteArrayInputStream(data));     
                float xscale = (float) resize_width / (float) bi.getWidth();
        		float yscale = (float) resize_height / (float) bi.getHeight();
        		
                float scale = xscale >=yscale? yscale:xscale;//取压缩比例小的
                int width = (int)(scale*(float) bi.getWidth());//压缩后的宽
                int height = (int)(scale*(float) bi.getHeight());//压缩后的高
        		
        		AffineTransform affineTransform = new AffineTransform();
        		affineTransform.setToScale(scale, scale);
            	
            	BufferedImage outputImage = new BufferedImage(width,height, BufferedImage.TYPE_INT_RGB);
            	Graphics2D gd2 = outputImage.createGraphics();
            	gd2.drawImage(bi, affineTransform,null);
            	gd2.dispose();

            	//转换成byte字节     
                ByteArrayOutputStream baos = new ByteArrayOutputStream();     
                ImageIO.write(outputImage, "jpeg", baos);     
                newdata = baos.toByteArray();  
        }catch(IOException e){      
             e.printStackTrace();      
        }      
        return newdata;     
    } 
    
    
    /**
     * 图片转换，将读取图片放大或缩小（固定长款压缩）
     * 
     * */
    public static  byte[] ChangeImgFixSize(byte[] data, int resize_width, int resize_height){     
        byte[] newdata = null;     
        try{      
                BufferedImage bi = ImageIO.read(new ByteArrayInputStream(data));     
                float xscale = (float) resize_width / (float) bi.getWidth();
        		float yscale = (float) resize_height / (float) bi.getHeight();
                
        		AffineTransform affineTransform = new AffineTransform();
        		affineTransform.setToScale(xscale, yscale);
            	
            	BufferedImage outputImage = new BufferedImage(resize_width,resize_height, BufferedImage.TYPE_INT_RGB);
            	Graphics2D gd2 = outputImage.createGraphics();
            	gd2.drawImage(bi, affineTransform,null);
            	gd2.dispose();

            	//转换成byte字节     
                ByteArrayOutputStream baos = new ByteArrayOutputStream();     
                ImageIO.write(outputImage, "jpeg", baos);     
                newdata = baos.toByteArray();  
        }catch(IOException e){      
             e.printStackTrace();      
        }      
        return newdata;     
    } 
    
}
