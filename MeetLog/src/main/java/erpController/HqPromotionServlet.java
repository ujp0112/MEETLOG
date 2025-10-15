package erpController;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import erpDto.Promotion;
import erpDto.PromotionFile;
import erpDto.PromotionImage;
import erpService.PromotionService;
import model.BusinessUser;
import util.AppConfig;

@WebServlet("/hq/promotion/*")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class HqPromotionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PromotionService promotionService = new PromotionService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
        if (user == null || !"HQ".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        long companyId = user.getCompanyId();
        
        String pathInfo = request.getPathInfo();
        
        // 작성/수정 폼 페이지 요청 (GET /hq/promotion/form)
        if ("/form".equals(pathInfo)) {
            String idStr = request.getParameter("id");
            if (idStr != null) { // 수정 모드
                Promotion promotion = promotionService.getPromotionById(companyId, Long.parseLong(idStr));
                request.setAttribute("promotion", promotion);
            }
            request.getRequestDispatcher("/WEB-INF/hq/promotion-form.jsp").forward(request, response);
            return;
        }
        
        // 목록 페이지 요청 (GET /hq/promotion)
        int page = 1;
        try { if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        int offset = (page - 1) * PAGE_SIZE;
        
        List<Promotion> promotions = promotionService.listPromotionsByCompany(companyId, PAGE_SIZE, offset);
        int totalCount = promotionService.getPromotionsCountByCompany(companyId);
        
        request.setAttribute("promotions", promotions);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/WEB-INF/hq/promotion-management.jsp").forward(request, response);
    }

 // HqPromotionServlet.java

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        BusinessUser user = (session == null) ? null : (BusinessUser) session.getAttribute("businessUser");
        if (user == null || !"HQ".equals(user.getRole())) { response.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        long companyId = user.getCompanyId();

        // 삭제 요청 처리
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            promotionService.deletePromotion(companyId, id);
            response.sendRedirect(request.getContextPath() + "/hq/promotion");
            return;
        }

        // 생성 및 수정 처리
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        Promotion promo = new Promotion();
        promo.setCompanyId(companyId);
        promo.setTitle(request.getParameter("title"));
        promo.setDescription(request.getParameter("description"));
        try {
            promo.setStartDate(sdf.parse(request.getParameter("startDate")));
            promo.setEndDate(sdf.parse(request.getParameter("endDate")));
        } catch (Exception e) { throw new ServletException("날짜 형식이 잘못되었습니다.", e); }

        // 삭제할 이미지/파일 ID 목록 수집
        List<Long> deleteImageIds = getDeleteIds(request, "deleteImageIds");
        List<Long> deleteFileIds = getDeleteIds(request, "deleteFileIds");

        // 새로 업로드된 이미지 처리
        List<PromotionImage> newImages = new ArrayList<>();
        int displayOrder = 1;
        for (Part part : request.getParts()) {
            if ("images".equals(part.getName()) && part.getSize() > 0) {
                String savedFilename = saveFile(part);
                PromotionImage pi = new PromotionImage();
                pi.setCompanyId(companyId);
                pi.setFilePath(savedFilename);
                pi.setDisplayOrder(displayOrder++);
                newImages.add(pi);
            }
        }
        promo.setImages(newImages);

        // 새로 업로드된 첨부파일 처리
        List<PromotionFile> newFiles = new ArrayList<>();
        for (Part part : request.getParts()) {
            if ("files".equals(part.getName()) && part.getSize() > 0) {
                String savedFilename = saveFile(part);
                PromotionFile pf = new PromotionFile();
                pf.setCompanyId(companyId);
                pf.setOriginalFilename(part.getSubmittedFileName());
                pf.setFilePath(savedFilename);
                pf.setFileSize(part.getSize());
                newFiles.add(pf);
            }
        }
        promo.setFiles(newFiles);
        
        // ID 유무에 따라 생성 또는 수정 호출
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) { // 수정
            promo.setId(Long.parseLong(idStr));
            promotionService.updatePromotion(promo, deleteImageIds, deleteFileIds);
        } else { // 생성
            promotionService.createPromotion(promo);
        }
        response.sendRedirect(request.getContextPath() + "/hq/promotion");
    }

    // 삭제할 ID 목록을 추출하는 헬퍼 메소드
    private List<Long> getDeleteIds(HttpServletRequest request, String paramName) {
        List<Long> idList = new ArrayList<>();
        String[] idParams = request.getParameterValues(paramName);
        if (idParams != null) {
            for (String id : idParams) {
                idList.add(Long.parseLong(id));
            }
        }
        return idList;
    }
    
    
    private String saveImage(Part part) throws IOException {
        if (part == null || part.getSize() <= 0) return null;
        String uploadPath = AppConfig.getUploadPath();
        String fileName = UUID.randomUUID().toString() + "_" + part.getSubmittedFileName();
        part.write(uploadPath + File.separator + fileName);
        return fileName;
    }
    
    
    
    private String saveFile(Part part) throws IOException {
        // 1. 파일이 없거나 비어있는지 확인
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        // 2. AppConfig를 통해 영구 저장 경로를 가져옴
        String uploadPath = AppConfig.getUploadPath();
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // 폴더가 없으면 생성
        }

        // 3. 고유한 파일명 생성 (원본 확장자 유지)
        String originalFilename = part.getSubmittedFileName();
        String extension = "";
        if (originalFilename != null && originalFilename.lastIndexOf('.') > 0) {
            extension = originalFilename.substring(originalFilename.lastIndexOf('.'));
        }
        String savedFilename = UUID.randomUUID().toString() + extension;

        // 4. 파일을 최종 경로에 저장
        part.write(uploadPath + File.separator + savedFilename);
        
        // 5. 저장된 파일명만 반환
        return savedFilename;
    }
}