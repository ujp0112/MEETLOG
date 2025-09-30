package service;

import dao.FaqDAO;
import model.Faq;

import java.util.List;

public class FaqService {
    private final FaqDAO faqDAO = new FaqDAO();

    public List<Faq> getAllFaqs() {
        return faqDAO.findAll();
    }

    public List<Faq> getActiveFaqsOrdered() {
        return faqDAO.findActiveOrdered();
    }

    public List<Faq> getFaqsByCategory(String category) {
        return faqDAO.findByCategory(category);
    }

    public Faq getFaqById(int id) {
        return faqDAO.findById(id);
    }

    public boolean createFaq(Faq faq) {
        try {
            return faqDAO.insert(faq) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: FAQ 생성 실패 - " + e.getMessage());
            return false;
        }
    }

    public boolean updateFaq(Faq faq) {
        try {
            return faqDAO.update(faq) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: FAQ 수정 실패 - " + e.getMessage());
            return false;
        }
    }

    public boolean deleteFaq(int id) {
        try {
            return faqDAO.delete(id) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: FAQ 삭제 실패 - " + e.getMessage());
            return false;
        }
    }

    public boolean toggleFaqStatus(int id, boolean isActive) {
        try {
            return faqDAO.updateActiveStatus(id, isActive) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: FAQ 상태 변경 실패 - " + e.getMessage());
            return false;
        }
    }

    public List<String> getDistinctCategories() {
        return faqDAO.findDistinctCategories();
    }

    public int getTotalFaqCount() {
        try {
            return faqDAO.countTotal();
        } catch (Exception e) {
            System.out.println("ERROR: FAQ 총 개수 조회 실패 - " + e.getMessage());
            return 0;
        }
    }

    public int getActiveFaqCount() {
        try {
            return faqDAO.countActive();
        } catch (Exception e) {
            System.out.println("ERROR: 활성 FAQ 개수 조회 실패 - " + e.getMessage());
            return 0;
        }
    }
}