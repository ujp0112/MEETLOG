package service;

import dao.InquiryDAO;
import model.Inquiry;

import java.util.List;

public class InquiryService {
    private final InquiryDAO inquiryDAO = new InquiryDAO();

    public List<Inquiry> getAllInquiries() {
        return inquiryDAO.findAll();
    }

    public List<Inquiry> getInquiriesByStatus(String status) {
        return inquiryDAO.findByStatus(status);
    }

    public Inquiry getInquiryById(int id) {
        return inquiryDAO.findById(id);
    }

    public List<Inquiry> getInquiriesByUserId(int userId) {
        return inquiryDAO.findByUserId(userId);
    }

    public boolean createInquiry(Inquiry inquiry) {
        try {
            return inquiryDAO.insert(inquiry) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Inquiry 생성 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateInquiry(Inquiry inquiry) {
        try {
            return inquiryDAO.update(inquiry) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Inquiry 수정 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateInquiryStatus(int id, String status) {
        try {
            return inquiryDAO.updateStatus(id, status) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Inquiry 상태 변경 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean replyToInquiry(int id, String reply, String status) {
        try {
            return inquiryDAO.updateReply(id, reply, status) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Inquiry 답변 등록 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteInquiry(int id) {
        try {
            return inquiryDAO.delete(id) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Inquiry 삭제 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalInquiryCount() {
        try {
            return inquiryDAO.countTotal();
        } catch (Exception e) {
            System.out.println("ERROR: Inquiry 총 개수 조회 실패 - " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public int getInquiryCountByStatus(String status) {
        try {
            return inquiryDAO.countByStatus(status);
        } catch (Exception e) {
            System.out.println("ERROR: Inquiry 상태별 개수 조회 실패 - " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
}