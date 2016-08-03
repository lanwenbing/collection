package com.collections.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.collections.model.FileMeta;
import com.collections.util.FileUtils;

@Controller  
@RequestMapping("/upload")
public class UploadController {


	private static final String DEFAULT_SUB_FOLDER_FORMAT_AUTO = "yyyyMMddHHmmss";
	
	protected Logger logger = Logger.getLogger(UploadController.class);

	private static  String PROJECT_PATH;

	private static String UPLOAD_PATH="titleimg"+File.separator;
	
	private static String UPLOAD_PATH_JSP = "titleimg/";
	
	LinkedList<FileMeta> files = new LinkedList<FileMeta>();
    FileMeta fileMeta = null;
    

	@RequestMapping("index")
	public String index(HttpServletRequest request){
		 
        return "index";  
	}
    
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
            expandedName = ".jpg";  
        } else if (uploadContentType.equals("image/png")  
                || uploadContentType.equals("image/x-png")) {  
            expandedName = ".png";  
        } else if (uploadContentType.equals("image/gif")) {  
            expandedName = ".gif";  
        } else if (uploadContentType.equals("image/bmp")) {  
            expandedName = ".bmp";  
        } else {  
            out.println("<script type=\"text/javascript\">");  
            out.println("window.parent.CKEDITOR.tools.callFunction(" + CKEditorFuncNum  
                    + ",''," + "'格式要求是.jpg/.gif/.bmp/.png');");  
            out.println("</script>");  
            return ;  
        }  
		if (file.getSize()> 600 * 1024) {  
            out.println("<script type=\"text/javascript\">");  
            out.println("window.parent.CKEDITOR.tools.callFunction(" + CKEditorFuncNum  
                    + ",''," + "'文件要小于600k');");  
            out.println("</script>");  
            return ;  
		}
		DateFormat df = new SimpleDateFormat(DEFAULT_SUB_FOLDER_FORMAT_AUTO);
		fileName = df.format(new Date())+expandedName;
		File newFile = FileUtils.createFile(PROJECT_PATH+UPLOAD_PATH +fileName);
		file.transferTo(newFile);
		
        out.println("<script type=\"text/javascript\">");  
        out.println("window.parent.CKEDITOR.tools.callFunction(" + CKEditorFuncNum  
                + ",'" + request.getSession().getServletContext().getContextPath()+"/img/" + fileName + "','')");  
        out.println("</script>");  
        return ;  
	}
	@RequestMapping("uploadArticleImg")
	@ResponseBody
	public String uplodaArticleImg(@RequestParam("upload")MultipartFile file,
			HttpServletRequest request, 
			HttpServletResponse response)
			throws IllegalStateException, IOException{
		PROJECT_PATH = request.getSession().getServletContext().getRealPath("/");
		String path = request.getServletPath();
		PrintWriter out =response.getWriter();
		String fileName=file.getOriginalFilename();
		String uploadContentType =file.getContentType();
		String expandedName ="";
		if (uploadContentType.equals("image/pjpeg")  
                || uploadContentType.equals("image/jpeg")) {  
            expandedName = ".jpg";  
        } else if (uploadContentType.equals("image/png")  
                || uploadContentType.equals("image/x-png")) {   
            expandedName = ".png";  
        } else if (uploadContentType.equals("image/gif")) {  
            expandedName = ".gif";  
        } else if (uploadContentType.equals("image/bmp")) {  
            expandedName = ".bmp";  
        } else {  
            out.println("<script type=\"text/javascript\">");  
            out.println("alert('only for jpg, png, gif or bmp')");  
            out.println("</script>");  
            return "articlemanagement";  
        }  
		if (file.getSize()> 600 * 1024) {  
            out.println("<script type=\"text/javascript\">");  
            out.println("alert('the size should be less than 600 px')");  
            out.println("</script>");  
            return "articlemanagement";  
		}
		DateFormat df = new SimpleDateFormat(DEFAULT_SUB_FOLDER_FORMAT_AUTO);
		fileName = df.format(new Date())+expandedName;
		String newFilePath = UPLOAD_PATH +fileName;
		File newFile = FileUtils.createFile(PROJECT_PATH+newFilePath);
		file.transferTo(newFile);
		
        
        out.println("<script type=\"text/javascript\">");  
        out.println("alert('upload success');");  
        out.println("</script>");  
        
        String imageDir = UPLOAD_PATH_JSP + fileName;

        return imageDir;   
	}
	
	
	/***************************************************
     * URL: /rest/controller/upload  
     * upload(): receives files
     * @param request : MultipartHttpServletRequest auto passed
     * @param response : HttpServletResponse auto passed
     * @return LinkedList<FileMeta> as json format
     ****************************************************/
	@RequestMapping(value="/uploadTitleImag", method = RequestMethod.POST)
	@ResponseBody
    public  LinkedList<FileMeta> upload(MultipartHttpServletRequest request, HttpServletResponse response) {
 
        //1. build an iterator
         Iterator<String> itr =  request.getFileNames();
         MultipartFile mpf = null;
 
         //2. get each file
         while(itr.hasNext()){
 
             //2.1 get next MultipartFile
             mpf = request.getFile(itr.next()); 
             System.out.println(mpf.getOriginalFilename() +" uploaded! "+files.size());
 
             //2.2 if files > 10 remove the first from the list
             if(files.size() >= 10)
                 files.pop();
             DateFormat df = new SimpleDateFormat(DEFAULT_SUB_FOLDER_FORMAT_AUTO);
             String filename = df.format(new Date()) + mpf.getOriginalFilename();
             //2.3 create new fileMeta
             fileMeta = new FileMeta();
             fileMeta.setFileName(filename);
             fileMeta.setFileSize(mpf.getSize()/1024+" Kb");
             fileMeta.setFileType(mpf.getContentType());
             String imageDir = UPLOAD_PATH_JSP + filename;
             fileMeta.setUrl(imageDir);
             
             try {
                fileMeta.setBytes(mpf.getBytes());
                PROJECT_PATH = request.getSession().getServletContext().getRealPath("/");
                String newFilePath = PROJECT_PATH+UPLOAD_PATH;
                FileUtils.createDir(newFilePath);
                FileCopyUtils.copy(mpf.getBytes(), new FileOutputStream(newFilePath+filename));
                
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
             //2.4 add to files
             files.add(fileMeta);
         }
        // result will be like this
        // [{"fileName":"app_engine-85x77.png","fileSize":"8 Kb","fileType":"image/png"},...]
        return files;
    }
    /***************************************************
     * URL: /rest/controller/get/{value}
     * get(): get file as an attachment
     * @param response : passed by the server
     * @param value : value from the URL
     * @return void
     ****************************************************/
    @RequestMapping(value = "/get/{value}", method = RequestMethod.GET)
     public void get(HttpServletResponse response,@PathVariable String value){
         FileMeta getFile = files.get(Integer.parseInt(value));
         try {      
                response.setContentType(getFile.getFileType());
                response.setHeader("Content-disposition", "attachment; filename=\""+getFile.getFileName()+"\"");
                FileCopyUtils.copy(getFile.getBytes(), response.getOutputStream());
         }catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
         }
     }
}

