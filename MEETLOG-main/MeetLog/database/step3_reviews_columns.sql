-- 3단계: 리뷰와 칼럼 데이터 삽입
USE meetlog;

-- 리뷰 샘플 데이터 (data.js 기반)
INSERT INTO reviews (restaurant_id, user_id, author, author_image, rating, content, likes) VALUES
(2, 1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '여기 진짜 분위기 깡패에요! 소개팅이나 데이트 초반에 가면 무조건 성공입니다.', 25),
(4, 2, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', 4, '일 끝나고 동료들이랑 갔는데, 스트레스가 확 풀리네요. 새로 나온 마늘간장치킨이 진짜 맛있어요.', 18),
(1, 3, '효녀딸', 'https://placehold.co/100x100/f87171/ffffff?text=U3', 5, '부모님 생신이라 모시고 갔는데 정말 좋아하셨어요. 음식 하나하나 정성이 느껴져요.', 32),
(10, 4, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 5, '역시 여름엔 평양냉면이죠. 이 집 육수는 정말 최고입니다.', 28),
(12, 4, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', 5, '가산에서 이만한 퀄리티의 삼겹살을 찾기 힘듭니다. 회식 장소로 강력 추천!', 35),
(13, 7, '가산직장인', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 4, '점심시간에 웨이팅은 좀 있지만, 든든하게 한 끼 해결하기에 최고입니다. 깍두기가 맛있어요.', 22),
(19, 6, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', 4, '산미있는 원두를 좋아하시면 여기입니다. 디저트 케이크도 괜찮았어요.', 19),
(14, 1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 4, '가산에서 파스타 먹고 싶을 때 가끔 들러요. 창가 자리가 분위기 좋아요.', 15),
(11, 1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', 5, '언제 가도 맛있는 곳! 비건식빵이 정말 최고예요. 쌀로 만들어서 그런지 속도 편하고 쫀득한 식감이 일품입니다. 다른 빵들도 다 맛있어서 갈 때마다 고민하게 되네요. 사장님도 친절하시고 매장도 깨끗해서 좋아요!', 25);

-- 칼럼 샘플 데이터 (data.js 기반)
INSERT INTO columns (user_id, author, author_image, title, content, image, tags, likes, views) VALUES
(6, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', '상도동 비건 빵집 우부래도 솔직 리뷰', '상도동에는 숨겨진 비건 빵 맛집들이 많습니다. 그 중에서도 제가 가장 사랑하는 곳은 바로 우부래도입니다. 특히 이곳의 쌀바게트는 정말 일품입니다. 겉은 바삭하고 속은 쫀득한 식감이 살아있죠.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTA4MDlfMTMy%2FMDAxNTY1MzM2MTcwMzk4.9NmHsQASfgCkZy89SlMtra01wiYkt4GSWuVLBs_vm4Ig.dbp9tpFpnLoTD7tjSTMKYqBCnBJIulvtZSDbjU6EEdsg.JPEG.hariyoyo%2FKakaoTalk_20190809_140115427_05.jpg&type=sc960_832', '["#상도동", "#비건", "#베이커리"]', 245, 1200),
(4, '미스터노포', 'https://placehold.co/150x150/93c5fd/ffffff?text=C2', '을지로 직장인들을 위한 최고의 평양냉면', '여름이면 어김없이 생각나는 평양냉면. 을지로의 수많은 노포 중에서도 평양면옥은 단연 최고라고 할 수 있습니다. 슴슴하면서도 깊은 육수 맛이 일품입니다. 점심시간에는 웨이팅이 길 수 있으니 조금 서두르는 것을 추천합니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTA3MDhfMTM4%2FMDAxNzUxOTM3MDgxMzg4.X3ArTpASVrp_B8rvyV-MoP42-WwO8bDzMz7Gt6TJfM4g.-5G-C_j45N7ColfwgCaYtqVMfDj-vzXOoWP5enQO5Iog.JPEG%2FrP2142571.jpg&type=sc960_832', '["#을지로", "#평양냉면", "#노포"]', 188, 890),
(4, '김맛잘알', 'https://placehold.co/150x150/fca5a5/ffffff?text=C1', '한식 다이닝의 정수, 강남 고미정 방문기', '특별한 날, 소중한 사람과 함께할 장소를 찾는다면 강남의 고미정을 추천합니다. 정갈한 상차림과 깊은 맛의 한정식 코스는 먹는 내내 감탄을 자아냅니다. 특히 부모님을 모시고 가기에 최고의 장소입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAxMTRfMjM0%2FMDAxNjczNjk0MDM1NTAz.ANz-hk6mmcWfqgTyGaWIGDyg33RuiHzT77do6XY82GYg.3oCTPQ4Vb1Ysg4rggldaWCInkQ-8dFlcvndoGR10bCYg.JPEG.izzyoh%2FIMG_8900.JPG&type=sc960_832', '["#한식", "#강남", "#데이트"]', 245, 1200),
(1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', '홍대 최고의 파스타, 데이트 성공 보장!', '홍대에서 데이트 약속이 잡혔다면 고민하지 말고 파스타 팩토리로 가세요. 분위기, 맛, 서비스 뭐 하나 빠지는 게 없는 곳입니다. 특히 트러플 크림 파스타는 꼭 먹어봐야 할 메뉴입니다.', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNTAzMjNfMTkx%2FMDAxNzQyNjU2NDEyOTEx.DtVYVBzNwUtX9LVu4PE8w_rbunJUe_rd-AjnhWcsEHcg.U1sqbW057SmnvNBhBR-pypk_vVZdAOAtuFx7xJlMjJog.JPEG%2F900%25A3%25DFDSC02533.JPG&type=sc960_832', '["#홍대", "#데이트", "#파스타"]', 188, 890),
(7, '가산직장인', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', '가산디지털단지 직장인 점심 맛집 BEST 3', '매일 반복되는 점심 메뉴 고민, 힘드시죠? G밸리 5년차 직장인이 추천하는 점심 맛집 리스트를 공개합니다. 직장인 국밥부터...', 'https://placehold.co/600x400/f97316/ffffff?text=국밥', '["#가산", "#직장인", "#점심"]', 312, 1500),
(2, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', '퇴근 후 한잔, 가산 이자카야 가디 방문기', '지친 하루의 피로를 풀어주는 시원한 맥주와 맛있는 안주. 가디 이자카야는 회식 2차 장소로도, 혼술하기에도 좋은 곳입니다.', 'https://placehold.co/600x400/14b8a6/ffffff?text=이자카야', '["#가산", "#이자카야", "#회식"]', 156, 780),
(6, '빵순이', 'https://item.kakaocdn.net/do/4f2c16435337b94a65d4613f785fded24022de826f725e10df604bf1b9725cfd', '성수동에서 발견한 인생 커피, 카페 클라우드', '수많은 성수동 카페들 속에서 보석 같은 곳을 발견했습니다. 바로 카페 클라우드입니다. 특히 이곳의 시그니처 라떼는...', 'https://d12zq4w4guyljn.cloudfront.net/750_750_20200519023624996_photo_66e859a6b19b.jpg', '["#성수동", "#카페", "#커피"]', 312, 1500),
(1, '데이트장인', 'https://placehold.co/100x100/e879f9/ffffff?text=U1', '이태원 수제버거의 정석, 브루클린 버거', '육즙 가득한 패티와 신선한 야채의 조화. 브루클린 버거는 언제나 옳은 선택입니다. 치즈 스커트 버거는 꼭 드셔보세요.', 'https://placehold.co/600x400/fb923c/ffffff?text=버거', '["#이태원", "#버거", "#수제"]', 199, 950),
(7, '가산직장인', 'https://placehold.co/150x150/a78bfa/ffffff?text=가산', 'G밸리 회식장소 끝판왕, 월화 G밸리점', '두툼한 목살과 삼겹살이 일품인 곳. 단체석도 잘 마련되어 있어 가산디지털단지 회식 장소로 이만한 곳이 없습니다.', 'https://placehold.co/600x400/ef4444/ffffff?text=고기', '["#가산", "#회식", "#고기"]', 410, 2000),
(2, '퇴근후한잔', 'https://placehold.co/100x100/22d3ee/ffffff?text=U2', '종로 치맥의 성지, 치맥 하우스를 가다', '바삭한 치킨과 시원한 생맥주의 조합은 진리입니다. 치맥 하우스는 다양한 종류의 수제 맥주를 맛볼 수 있어 더욱 좋습니다.', 'https://placehold.co/600x400/fbbf24/ffffff?text=치킨', '["#종로", "#치맥", "#수제맥주"]', 267, 1300);

-- 예약 샘플 데이터
INSERT INTO reservations (restaurant_id, user_id, restaurant_name, user_name, reservation_time, party_size, status, contact_phone) VALUES
(11, 1, '우부래도', '데이트장인', '2025-09-14 19:00:00', 2, 'CONFIRMED', '010-1234-5678'),
(2, 2, '파스타 팩토리', '퇴근후한잔', '2025-09-13 20:00:00', 4, 'COMPLETED', '010-2345-6789'),
(32, 3, '툭툭누들타이', '효녀딸', '2025-08-15 18:30:00', 2, 'CANCELED', '010-3456-7890');

-- 팔로우 샘플 데이터
INSERT INTO follows (follower_id, following_id) VALUES
(2, 1), -- 퇴근후한잔이 데이트장인을 팔로우
(3, 1), -- 효녀딸이 데이트장인을 팔로우
(1, 4), -- 데이트장인이 김맛잘알을 팔로우
(1, 5), -- 데이트장인이 미스터노포를 팔로우
(1, 6), -- 데이트장인이 빵순이를 팔로우
(2, 4), -- 퇴근후한잔이 김맛잘알을 팔로우
(3, 6); -- 효녀딸이 빵순이를 팔로우
