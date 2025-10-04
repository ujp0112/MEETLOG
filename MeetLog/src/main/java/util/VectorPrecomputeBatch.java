package util;

import adapter.KoBertAdapter;
import dao.RecommendationDAO;
import model.Restaurant;
import service.port.RecommendationPort;

import java.util.List;

/**
 * 레스토랑 콘텐츠 벡터를 사전 계산하여 DB에 저장하는 배치 작업 유틸리티
 *
 * 사용법:
 * java -cp MeetLog.war util.VectorPrecomputeBatch [batchSize]
 */
public class VectorPrecomputeBatch {

    private final RecommendationDAO dao;
    private final RecommendationPort koBertPort;

    public VectorPrecomputeBatch() {
        this.dao = new RecommendationDAO();
        this.koBertPort = new KoBertAdapter();
    }

    /**
     * 벡터가 없는 레스토랑들에 대해 벡터를 계산하여 저장
     */
    public void processBatch(int batchSize) {
        System.out.println("=== 레스토랑 벡터 사전 계산 시작 ===");
        System.out.println("배치 크기: " + batchSize);

        List<Integer> restaurantIds = dao.getRestaurantsWithoutVectors(batchSize);
        System.out.println("처리 대상 레스토랑 수: " + restaurantIds.size());

        int successCount = 0;
        int failCount = 0;

        for (int i = 0; i < restaurantIds.size(); i++) {
            Integer restaurantId = restaurantIds.get(i);
            System.out.println("\n[" + (i + 1) + "/" + restaurantIds.size() + "] 처리 중: 레스토랑 ID " + restaurantId);

            try {
                // 레스토랑 정보 조회
                Restaurant restaurant = dao.getRestaurantById(restaurantId);
                if (restaurant == null) {
                    System.err.println("레스토랑을 찾을 수 없음: ID " + restaurantId);
                    failCount++;
                    continue;
                }

                // 콘텐츠 텍스트 생성 (이름, 카테고리, 설명 결합)
                String contentText = buildContentText(restaurant);
                System.out.println("콘텐츠 텍스트: " + contentText.substring(0, Math.min(50, contentText.length())) + "...");

                // KoBERT를 통해 벡터 생성
                double[] vector = koBertPort.getVectorFromText(contentText);
                if (vector == null) {
                    System.err.println("벡터 생성 실패: ID " + restaurantId);
                    failCount++;
                    continue;
                }

                // DB에 벡터 저장
                int result = dao.upsertRestaurantVector(restaurantId, vector, contentText);
                if (result > 0) {
                    System.out.println("✓ 벡터 저장 완료 (차원: " + vector.length + ")");
                    successCount++;
                } else {
                    System.err.println("✗ 벡터 저장 실패");
                    failCount++;
                }

            } catch (Exception e) {
                System.err.println("✗ 예외 발생: " + e.getMessage());
                e.printStackTrace();
                failCount++;
            }

            // API 과부하 방지를 위한 딜레이
            if (i < restaurantIds.size() - 1) {
                try {
                    Thread.sleep(200); // 200ms 대기
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        }

        System.out.println("\n=== 처리 완료 ===");
        System.out.println("성공: " + successCount);
        System.out.println("실패: " + failCount);
        System.out.println("전체: " + restaurantIds.size());
    }

    /**
     * 레스토랑 정보를 기반으로 콘텐츠 텍스트 생성
     */
    private String buildContentText(Restaurant restaurant) {
        StringBuilder sb = new StringBuilder();

        // 이름
        if (restaurant.getName() != null) {
            sb.append(restaurant.getName()).append(". ");
        }

        // 카테고리
        if (restaurant.getCategory() != null) {
            sb.append(restaurant.getCategory()).append(" 음식점. ");
        }

        // 설명
        if (restaurant.getDescription() != null && !restaurant.getDescription().isBlank()) {
            sb.append(restaurant.getDescription()).append(" ");
        }

        // 위치
        if (restaurant.getLocation() != null) {
            sb.append(restaurant.getLocation()).append(" 지역. ");
        }

        String text = sb.toString().trim();
        return text.isEmpty() ? restaurant.getName() : text;
    }

    public static void main(String[] args) {
        int batchSize = 50; // 기본값

        if (args.length > 0) {
            try {
                batchSize = Integer.parseInt(args[0]);
            } catch (NumberFormatException e) {
                System.err.println("잘못된 배치 크기. 기본값 50 사용.");
            }
        }

        VectorPrecomputeBatch batch = new VectorPrecomputeBatch();
        batch.processBatch(batchSize);
    }
}
