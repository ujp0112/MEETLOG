package controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.google.gson.JsonObject; // Gson 라이브러리 필요 (pom.xml에 추가)

import util.AppConfig;

@WebServlet("/api/column/image-upload")
public class ColumnImageUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 서버의 업로드 경로를 AppConfig에서 가져옵니다.
        String uploadPath = AppConfig.getUploadPath();
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setHeaderEncoding("UTF-8");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            List<FileItem> items = upload.parseRequest(request);
            for (FileItem item : items) {
                // 'file'은 TinyMCE가 이미지를 보낼 때 사용하는 기본 필드명입니다.
                if (!item.isFormField() && "file".equals(item.getFieldName())) {
                    String originalFileName = new File(item.getName()).getName();
                    String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                    String savedFileName = UUID.randomUUID().toString() + fileExtension;
                    
                    File storeFile = new File(uploadPath, savedFileName);
                    item.write(storeFile);

                    // ImageServlet을 통해 접근할 수 있는 URL을 생성합니다.
                    String imageUrl = request.getContextPath() + "/images/" + savedFileName;
                    
                    // TinyMCE가 요구하는 JSON 형식: {"location": "이미지 URL"}
                    jsonResponse.addProperty("location", imageUrl);
                    
                    out.print(jsonResponse.toString());
                    out.flush();
                    return; // 파일 하나만 처리하고 종료
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("error", "이미지 업로드에 실패했습니다: " + e.getMessage());
            out.print(jsonResponse.toString());
            out.flush();
            e.printStackTrace();
        }
    }
}