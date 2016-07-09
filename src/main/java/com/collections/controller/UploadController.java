package com.collections.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.collections.util.FileUtils;

@Controller  
@RequestMapping("/upload")
public class UploadController {


	private static final String DEFAULT_SUB_FOLDER_FORMAT_AUTO = "yyyyMMddHHmmss";
	
	protected Logger logger = Logger.getLogger(UploadController.class);

	private static  String PROJECT_PATH;

	private static String UPLOAD_PATH="img"+File.separator;

	@RequestMapping("uploadImg")
	public void uplodaImg(@RequestParam("upload")MultipartFile file,
			HttpServletRequest request, 
			HttpServletResponse response,
			@RequestParam("CKEditorFuncNum")String CKEditorFuncNum)
			throws IllegalStateException, IOException{
		PROJECT_PATH = request.getSession().getServletContext().getRealPath("/");
		PrintWriter out =response.getWriter();
		String fileName=file.getOriginalFilename();
		String uploadContentType =file.getContentType();
		String expandedName ="";
		if (uploadContentType.equals("image/pjpeg")  
                || uploadContentType.equals("image/jpeg")) {  
            // IE6�ϴ�jpgͼƬ��headimageContentType��image/pjpeg����IE9�Լ�����ϴ���jpgͼƬ��image/jpeg  
            expandedName = ".jpg";  
        } else if (uploadContentType.equals("image/png")  
                || uploadContentType.equals("image/x-png")) {  
            // IE6�ϴ���pngͼƬ��headimageContentType��"image/x-png"  
            expandedName = ".png";  
        } else if (uploadContentType.equals("image/gif")) {  
            expandedName = ".gif";  
        } else if (uploadContentType.equals("image/bmp")) {  
            expandedName = ".bmp";  
        } else {  
            out.println("<script type=\"text/javascript\">");  
            out.println("window.parent.CKEDITOR.tools.callFunction(" + CKEditorFuncNum  
                    + ",''," + "'�ļ���ʽ����ȷ������Ϊ.jpg/.gif/.bmp/.png�ļ���');");  
            out.println("</script>");  
            return ;  
        }  
		if (file.getSize()> 600 * 1024) {  
            out.println("<script type=\"text/javascript\">");  
            out.println("window.parent.CKEDITOR.tools.callFunction(" + CKEditorFuncNum  
                    + ",''," + "'�ļ���С���ô���600k');");  
            out.println("</script>");  
            return ;  
		}
		DateFormat df = new SimpleDateFormat(DEFAULT_SUB_FOLDER_FORMAT_AUTO);
		fileName = df.format(new Date())+expandedName;
		File newFile = FileUtils.createFile(PROJECT_PATH+UPLOAD_PATH +fileName);
		file.transferTo(newFile);
		
        // ����"ͼ��"ѡ�����ʾͼƬ  request.getContextPath()Ϊweb��Ŀ��   
        out.println("<script type=\"text/javascript\">");  
        out.println("window.parent.CKEDITOR.tools.callFunction(" + CKEditorFuncNum  
                + ",'" + request.getSession().getServletContext().getContextPath()+"/img/" + fileName + "','')");  
        out.println("</script>");  
        return ;  
	}
	
}
