package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.AppConfig; // 3단계에서 만든 설정 클래스 임포트

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String fileName = URLDecoder.decode(pathInfo.substring(1), "UTF-8");
        
        // AppConfig를 통해 설정 파일에 정의된 경로를 가져옴
        String uploadPath = AppConfig.getUploadPath();
        if (uploadPath == null || uploadPath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "업로드 경로가 설정되지 않았습니다.");
            return;
        }

        File imageFile = new File(uploadPath, fileName);

        if (imageFile.exists() && imageFile.isFile()) {
            response.setContentType(getServletContext().getMimeType(fileName));
            response.setContentLength((int) imageFile.length());

            try (FileInputStream in = new FileInputStream(imageFile);
                 OutputStream out = response.getOutputStream()) {
                
                byte[] buffer = new byte[1024 * 8];
                int count = 0;
                while ((count = in.read(buffer)) != -1) {
                    out.write(buffer, 0, count);
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}