package erpService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import erpDto.Notice;
import erpDto.NoticeFile;
import erpDto.NoticeImage;
import util.MyBatisSqlSessionFactory;

public class NoticeService {

	public void createNotice(Notice notice) {
		SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
		try {
			// 1. 공지사항 본문 저장 (notice_id가 생성됨)
			session.insert("erpMapper.NoticeMapper.insertNotice", notice);
			
			// 2. [추가된 로직] 이미지 목록 저장
			if (notice.getImages() != null && !notice.getImages().isEmpty()) {
				for (NoticeImage image : notice.getImages()) {
					image.setNoticeId(notice.getId()); // 생성된 공지 ID 설정
				}
				session.insert("erpMapper.NoticeMapper.insertNoticeImages", notice.getImages());
			}

			// 3. 첨부파일 목록 저장
			if (notice.getFiles() != null && !notice.getFiles().isEmpty()) {
				for (NoticeFile file : notice.getFiles()) {
					file.setNoticeId(notice.getId()); // 생성된 공지 ID 설정
				}
				session.insert("erpMapper.NoticeMapper.insertNoticeFiles", notice.getFiles());
			}
			session.commit();
		} catch (Exception e) {
			session.rollback();
			throw new RuntimeException("공지사항 생성 중 오류 발생", e);
		} finally {
			session.close();
		}
	}


	// [수정] 파일/이미지 보존 로직을 명확히 하기 위해 boolean 플래그 파라미터 추가
    public void updateNotice(Notice notice, 
                             boolean imagesUpdated, boolean filesUpdated, 
                             List<Long> deleteImageIds, List<Long> deleteFileIds) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            session.update("erpMapper.NoticeMapper.updateNotice", notice);

            if (deleteImageIds != null && !deleteImageIds.isEmpty()) {
                session.delete("erpMapper.NoticeMapper.deleteImagesByIds", deleteImageIds);
            }
            if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
                session.delete("erpMapper.NoticeMapper.deleteFilesByIds", deleteFileIds);
            }

            // 새 이미지가 업로드된 경우에만 새로 추가
            if (imagesUpdated && notice.getImages() != null && !notice.getImages().isEmpty()) {
                for (NoticeImage image : notice.getImages()) {
                    image.setNoticeId(notice.getId());
                }
                session.insert("erpMapper.NoticeMapper.insertNoticeImages", notice.getImages());
            }

            // 새 첨부파일이 업로드된 경우에만 새로 추가
            if (filesUpdated && notice.getFiles() != null && !notice.getFiles().isEmpty()) {
                for (NoticeFile file : notice.getFiles()) {
                    file.setNoticeId(notice.getId());
                }
                session.insert("erpMapper.NoticeMapper.insertNoticeFiles", notice.getFiles());
            }
            
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw new RuntimeException("공지사항 수정 중 오류 발생", e);
        } finally {
            session.close();
        }
    }

	// 공지사항 삭제
	public void deleteNotice(long companyId, long noticeId) {
		try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
			session.update("erpMapper.NoticeMapper.softDeleteNotice",
					Map.of("companyId", companyId, "noticeId", noticeId));
		}
	}
	// NoticeService.java에 아래 메소드들 추가

	/**
	 * 특정 회사의 공지사항 목록을 페이징하여 조회합니다.
	 * 
	 * @param companyId 회사 ID
	 * @param limit     한 페이지에 보여줄 개수
	 * @param offset    시작 위치
	 * @return 공지사항 목록
	 */
	public List<Notice> listNotices(long companyId, int limit, int offset) {
		try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
			Map<String, Object> params = new HashMap<>();
			params.put("companyId", companyId);
			params.put("limit", limit);
			params.put("offset", offset);
			return session.selectList("erpMapper.NoticeMapper.selectNoticesByCompany", params);
		}
	}

	/**
	 * 특정 회사의 전체 공지사항 개수를 조회합니다. (페이지네이션용)
	 * 
	 * @param companyId 회사 ID
	 * @return 전체 공지사항 개수
	 */
	public int getNoticeCount(long companyId) {
		try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
			return session.selectOne("erpMapper.NoticeMapper.countNoticesByCompany", companyId);
		}
	}

	/**
	 * 특정 공지사항의 상세 정보를 첨부파일과 함께 조회합니다.
	 * 
	 * @param companyId 회사 ID
	 * @param noticeId  공지사항 ID
	 * @return 첨부파일을 포함한 공지사항 객체
	 */
	// NoticeService.java
	public Notice getNoticeById(long companyId, long noticeId) {
	    SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
	    try {
	        // 1. 조회수 1 증가
	        session.update("erpMapper.NoticeMapper.incrementNoticeViewCount", noticeId);
	        
	        // 2. 데이터 조회
	        Map<String, Object> params = new HashMap<>();
	        params.put("companyId", companyId);
	        params.put("noticeId", noticeId);
	        Notice notice = session.selectOne("erpMapper.NoticeMapper.selectNoticeById", params);
	        
	        // 3. 트랜잭션 커밋
	        session.commit();
	        return notice;
	    } catch (Exception e) {
	        session.rollback();
	        throw new RuntimeException("공지사항 상세 조회 중 오류 발생", e);
	    } finally {
	        session.close();
	    }
	}
}