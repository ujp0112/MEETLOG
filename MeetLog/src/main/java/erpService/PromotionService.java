package erpService;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import erpDto.Promotion;
import erpDto.PromotionFile;
import erpDto.PromotionImage;
import util.MyBatisSqlSessionFactory;

public class PromotionService {

    public void createPromotion(Promotion promo) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            session.insert("erpMapper.PromotionMapper.insertPromotion", promo);
            
            if (promo.getImages() != null && !promo.getImages().isEmpty()) {
                for (PromotionImage image : promo.getImages()) {
                    image.setPromotionId(promo.getId());
                }
                session.insert("erpMapper.PromotionMapper.insertPromotionImages", promo.getImages());
            }
            if (promo.getFiles() != null && !promo.getFiles().isEmpty()) {
                for (PromotionFile file : promo.getFiles()) {
                    file.setPromotionId(promo.getId());
                }
                session.insert("erpMapper.PromotionMapper.insertPromotionFiles", promo.getFiles());
            }
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw new RuntimeException("프로모션 생성 중 오류 발생", e);
        } finally {
            session.close();
        }
    }

    public void updatePromotion(Promotion promo, List<Long> deleteImageIds, List<Long> deleteFileIds) {
        SqlSession session = MyBatisSqlSessionFactory.getSqlSession();
        try {
            session.update("erpMapper.PromotionMapper.updatePromotion", promo);

            if (deleteImageIds != null && !deleteImageIds.isEmpty()) {
                session.delete("erpMapper.PromotionMapper.deleteImagesByIds", deleteImageIds);
            }
            if (deleteFileIds != null && !deleteFileIds.isEmpty()) {
                session.delete("erpMapper.PromotionMapper.deleteFilesByIds", deleteFileIds);
            }

            if (promo.getImages() != null && !promo.getImages().isEmpty()) {
                for (PromotionImage image : promo.getImages()) {
                    image.setPromotionId(promo.getId());
                }
                session.insert("erpMapper.PromotionMapper.insertPromotionImages", promo.getImages());
            }

            if (promo.getFiles() != null && !promo.getFiles().isEmpty()) {
                for (PromotionFile file : promo.getFiles()) {
                    file.setPromotionId(promo.getId());
                }
                session.insert("erpMapper.PromotionMapper.insertPromotionFiles", promo.getFiles());
            }
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw new RuntimeException("프로모션 수정 중 오류 발생", e);
        } finally {
            session.close();
        }
    }

    public Promotion getPromotionById(long companyId, long id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("erpMapper.PromotionMapper.selectPromotionById", Map.of("companyId", companyId, "id", id));
        }
    }

    public List<Promotion> listPromotionsByCompany(long companyId, int limit, int offset) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("erpMapper.PromotionMapper.listPromotionsByCompany", Map.of("companyId", companyId, "limit", limit, "offset", offset));
        }
    }

    public int getPromotionsCountByCompany(long companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectOne("erpMapper.PromotionMapper.countPromotionsByCompany", companyId);
        }
    }
    
    public void deletePromotion(long companyId, long id) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            session.update("erpMapper.PromotionMapper.softDeletePromotion", Map.of("companyId", companyId, "id", id));
        }
    }
    
    public List<Promotion> listActivePromotionsForBranch(long companyId) {
        try (SqlSession session = MyBatisSqlSessionFactory.getSqlSession()) {
            return session.selectList("erpMapper.PromotionMapper.listActivePromotionsForBranch", Map.of("companyId", companyId));
        }
    }
}