package service;

import dao.NoticeDAO;
import model.Notice;

import java.util.List;

public class NoticeService {
    private final NoticeDAO noticeDAO = new NoticeDAO();

    public List<Notice> getAllNotices() {
        return noticeDAO.findAll();
    }

    public Notice getNoticeById(int id) {
        return noticeDAO.findById(id);
    }

    public List<Notice> getRecentNotices(int limit) {
        return noticeDAO.findRecent(limit);
    }

    public boolean createNotice(Notice notice) {
        try {
            return noticeDAO.insert(notice) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Notice 생성 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateNotice(Notice notice) {
        try {
            return noticeDAO.update(notice) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Notice 수정 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteNotice(int id) {
        try {
            return noticeDAO.delete(id) > 0;
        } catch (Exception e) {
            System.out.println("ERROR: Notice 삭제 실패 - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalNoticeCount() {
        try {
            return noticeDAO.countTotal();
        } catch (Exception e) {
            System.out.println("ERROR: Notice 총 개수 조회 실패 - " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
}