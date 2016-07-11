package com.collections.util;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.Logger;

public class FileUtils {

	private static Logger logger = Logger.getLogger(FileUtils.class);
	
    public static File createFile(String destFileName) {
    	
        File file = new File(destFileName);
        if(file.exists()) {
        	logger.info("���������ļ�" + destFileName + "ʧ�ܣ�Ŀ���ļ��Ѵ��ڣ�");
        }
        if (destFileName.endsWith(File.separator)) {
        	logger.info("���������ļ�" + destFileName + "ʧ�ܣ�Ŀ���ļ�����ΪĿ¼��");
        }
        //�ж�Ŀ���ļ����ڵ�Ŀ¼�Ƿ����
        if(!file.getParentFile().exists()) {
            //���Ŀ���ļ����ڵ�Ŀ¼�����ڣ��򴴽���Ŀ¼
        	logger.info("Ŀ���ļ�����Ŀ¼�����ڣ�׼����������");
            if(!file.getParentFile().mkdirs()) {
            	logger.info("����Ŀ���ļ�����Ŀ¼ʧ�ܣ�");
            }
        }
        
        //����Ŀ���ļ�
        try {
            if (file.createNewFile()) {
            	logger.info("���������ļ�" + destFileName + "�ɹ���");
            } else {
            	logger.info("���������ļ�" + destFileName + "ʧ�ܣ�");
            }
        } catch (IOException e) {
            e.printStackTrace();
            logger.info("���������ļ�" + destFileName + "ʧ�ܣ�" + e.getMessage());
        }
        return file;
    }
   
   
    public static boolean createDir(String destDirName) {
        File dir = new File(destDirName);
        if (dir.exists()) {
            System.out.println("����Ŀ¼" + destDirName + "ʧ�ܣ�Ŀ��Ŀ¼�Ѿ�����");
            return false;
        }
        if (!destDirName.endsWith(File.separator)) {
            destDirName = destDirName + File.separator;
        }
        //����Ŀ¼
        if (dir.mkdirs()) {
            System.out.println("����Ŀ¼" + destDirName + "�ɹ���");
            return true;
        } else {
            System.out.println("����Ŀ¼" + destDirName + "ʧ�ܣ�");
            return false;
        }
    }
   
   
    public static String createTempFile(String prefix, String suffix, String dirName) {
        File tempFile = null;
        if (dirName == null) {
            try{
                //��Ĭ���ļ����´�����ʱ�ļ�
                tempFile = File.createTempFile(prefix, suffix);
                //������ʱ�ļ���·��
                return tempFile.getCanonicalPath();
            } catch (IOException e) {
                e.printStackTrace();
                System.out.println("������ʱ�ļ�ʧ�ܣ�" + e.getMessage());
                return null;
            }
        } else {
            File dir = new File(dirName);
            //�����ʱ�ļ�����Ŀ¼�����ڣ����ȴ���
            if (!dir.exists()) {
                if (!createDir(dirName)) {
                    System.out.println("������ʱ�ļ�ʧ�ܣ����ܴ�����ʱ�ļ����ڵ�Ŀ¼��");
                    return null;
                }
            }
            try {
                //��ָ��Ŀ¼�´�����ʱ�ļ�
                tempFile = File.createTempFile(prefix, suffix, dir);
                return tempFile.getCanonicalPath();
            } catch (IOException e) {
                e.printStackTrace();
                System.out.println("������ʱ�ļ�ʧ�ܣ�" + e.getMessage());
                return null;
            }
        }
    }
   
    public static void main(String[] args) {
        //����Ŀ¼
        String dirName = "D:/work/temp/temp0/temp1";
        createDir(dirName);
        //�����ļ�
        String fileName = dirName + "/temp2/tempFile.txt";
        createFile(fileName);
        //������ʱ�ļ�
        String prefix = "temp";
        String suffix = ".txt";
        for (int i = 0; i < 10; i++) {
            System.out.println("��������ʱ�ļ���"
                    + createTempFile(prefix, suffix, dirName));
        }
        //��Ĭ��Ŀ¼�´�����ʱ�ļ�
        for (int i = 0; i < 10; i++) {
            System.out.println("��Ĭ��Ŀ¼�´�������ʱ�ļ���"
                    + createTempFile(prefix, suffix, null));
        }
    }

	
}
