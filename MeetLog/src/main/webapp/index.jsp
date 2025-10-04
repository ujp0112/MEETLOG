<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MEET LOG - 나에게 꼭 맞는 맛집</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-slate-50 text-slate-900">
  <div id="app" class="flex min-h-screen flex-col">
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="flex-grow">
      <section class="relative isolate overflow-hidden bg-slate-900 text-white">
        <img src="https://images.unsplash.com/photo-1447933601403-0c6688de566e?q=80&w=2000&auto=format&fit=crop" alt="다양한 음식이 차려진 테이블" class="absolute inset-0 h-full w-full object-cover opacity-40">
        <div class="absolute inset-0 bg-gradient-to-br from-slate-950 via-slate-900/80 to-sky-900/70"></div>

        <div class="relative z-10">
          <div class="container mx-auto px-4 py-20 md:py-28">
            <div class="max-w-3xl">
              <span class="inline-flex items-center rounded-full bg-white/10 px-4 py-1 text-sm font-semibold uppercase tracking-wide">취향 맞춤 맛집 탐험</span>
              <h1 class="mt-6 text-4xl font-black leading-tight md:text-6xl">
                수많은 리뷰 속에서 <span class="text-sky-300">내 입맛</span>을 찾는 가장 빠른 방법
              </h1>
              <p class="mt-6 text-lg text-slate-100 md:text-xl">
                지역·카테고리 추천부터 팔로우 피드까지, MEET LOG가 검증한 데이터로 실패 없는 미식 루트를 만들어 드립니다.
              </p>

              <form action="${pageContext.request.contextPath}/restaurant/list" method="get" role="search" class="mt-10 flex flex-col gap-4 rounded-3xl bg-white/10 p-6 backdrop-blur">
                <div class="flex flex-col gap-4 md:flex-row">
                  <label for="landingKeyword" class="sr-only">검색 키워드</label>
                  <input id="landingKeyword" name="keyword" type="text" placeholder="예: 홍대 파스타, 강남 한우" autocomplete="off" class="w-full flex-1 rounded-2xl border border-white/30 bg-white/10 px-6 py-4 text-base text-white placeholder:text-slate-300 focus:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-300/60">
                  <label for="landingCategory" class="sr-only">카테고리</label>
                  <select id="landingCategory" name="category" class="rounded-2xl border border-white/30 bg-white/10 px-6 py-4 text-base text-white focus:border-sky-300 focus:outline-none focus:ring-2 focus:ring-sky-300/60">
                    <option value="" class="text-slate-900">전체</option>
                    <option value="한식" class="text-slate-900">한식</option>
                    <option value="양식" class="text-slate-900">양식</option>
                    <option value="일식" class="text-slate-900">일식</option>
                    <option value="중식" class="text-slate-900">중식</option>
                    <option value="카페" class="text-slate-900">카페</option>
                  </select>
                </div>
                <div class="flex flex-col gap-3 text-sm md:flex-row md:items-center">
                  <button type="submit" class="inline-flex items-center justify-center rounded-full bg-sky-500 px-8 py-4 text-base font-semibold text-white shadow-lg shadow-sky-500/30 hover:bg-sky-600 focus:outline-none focus:ring-2 focus:ring-sky-300">맛집 찾기</button>
                  <a href="${pageContext.request.contextPath}/searchRestaurant?keyword=&category=전체" class="inline-flex items-center justify-center rounded-full bg-white/10 px-8 py-4 text-base font-semibold text-white hover:bg-white/20">지도에서 보기</a>
                  <div class="flex flex-wrap gap-2 text-white/70 md:ml-auto md:flex-none">
                    <span class="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1">
                      <span class="h-1.5 w-1.5 rounded-full bg-emerald-400"></span> 실시간 랭킹 업데이트
                    </span>
                    <span class="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1">
                      <span class="h-1.5 w-1.5 rounded-full bg-sky-300"></span> 팔로우 취향 반영
                    </span>
                  </div>
                </div>
              </form>

              <div class="mt-12 grid gap-6 sm:grid-cols-3">
                <div class="rounded-2xl bg-white/10 p-5 text-center">
                  <p class="text-3xl font-black text-white">82K+</p>
                  <p class="mt-2 text-sm text-slate-200">실제 리뷰 기반 데이터</p>
                </div>
                <div class="rounded-2xl bg-white/10 p-5 text-center">
                  <p class="text-3xl font-black text-white">97%</p>
                  <p class="mt-2 text-sm text-slate-200">추천 만족도</p>
                </div>
                <div class="rounded-2xl bg-white/10 p-5 text-center">
                  <p class="text-3xl font-black text-white">24/7</p>
                  <p class="mt-2 text-sm text-slate-200">지점·HQ 통합 지원</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="bg-white py-16 md:py-20">
        <div class="container mx-auto px-4">
          <div class="mx-auto max-w-2xl text-center">
            <h2 class="text-3xl font-bold md:text-4xl">MEET LOG만의 3가지 차별점</h2>
            <p class="mt-4 text-base text-slate-600 md:text-lg">취향 데이터, 예약 동선, 팔로우 네트워크까지 하나의 경험으로 연결합니다.</p>
          </div>

          <div class="mt-14 grid gap-6 md:grid-cols-3">
            <article class="group relative overflow-hidden rounded-3xl border border-slate-100 bg-slate-50 p-8 shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
              <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-sky-100 text-2xl">🎯</div>
              <h3 class="mt-6 text-xl font-semibold text-slate-900">입맛 맞춤 추천 엔진</h3>
              <p class="mt-3 text-sm leading-relaxed text-slate-600">검색어와 기록을 결합한 취향 레이어로, 나와 비슷한 사람들의 찐 후기만 선별해서 보여줍니다.</p>
              <span class="mt-6 inline-flex items-center text-sm font-semibold text-sky-600">알고리즘 살펴보기 →</span>
            </article>

            <article class="group relative overflow-hidden rounded-3xl border border-slate-100 bg-slate-50 p-8 shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
              <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-emerald-100 text-2xl">🗓️</div>
              <h3 class="mt-6 text-xl font-semibold text-slate-900">예약과 코스 한 번에</h3>
              <p class="mt-3 text-sm leading-relaxed text-slate-600">이동 시간과 동선까지 고려한 코스를 즉시 생성하고, 예약까지 같은 화면에서 이어집니다.</p>
              <span class="mt-6 inline-flex items-center text-sm font-semibold text-emerald-600">코스 만들기 →</span>
            </article>

            <article class="group relative overflow-hidden rounded-3xl border border-slate-100 bg-slate-50 p-8 shadow-sm transition hover:-translate-y-1 hover:shadow-xl">
              <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-rose-100 text-2xl">🤝</div>
              <h3 class="mt-6 text-xl font-semibold text-slate-900">팔로우 기반 미식 네트워크</h3>
              <p class="mt-3 text-sm leading-relaxed text-slate-600">믿을 수 있는 칼럼니스트를 팔로우하면, 그들의 맛집 지도가 내 피드에 바로 반영됩니다.</p>
              <span class="mt-6 inline-flex items-center text-sm font-semibold text-rose-600">칼럼 탐색하기 →</span>
            </article>
          </div>
        </div>
      </section>

      <section class="bg-slate-900 py-16 text-white md:py-20">
        <div class="container mx-auto px-4">
          <div class="flex flex-col gap-10 lg:flex-row lg:items-center">
            <div class="flex-1">
              <h2 class="text-3xl font-bold md:text-4xl">실제 추천 화면 미리보기</h2>
              <p class="mt-4 text-slate-200">메인 화면에서 바로 확인할 수 있는 맞춤 리스트, 실시간 랭킹, 그리고 팔로우 피드를 한 번에 엿보세요.</p>
              <ul class="mt-8 space-y-4 text-sm leading-relaxed text-slate-200">
                <li class="flex items-start gap-3"><span class="mt-1 h-2 w-2 rounded-full bg-sky-300"></span><span>내 주변 인기 TOP5를 실시간으로 업데이트</span></li>
                <li class="flex items-start gap-3"><span class="mt-1 h-2 w-2 rounded-full bg-sky-300"></span><span>팔로우한 사람들의 최신 리뷰와 사진을 카드 형식으로</span></li>
                <li class="flex items-start gap-3"><span class="mt-1 h-2 w-2 rounded-full bg-sky-300"></span><span>예약 가능 여부, 인기 시간대까지 한눈에 확인</span></li>
              </ul>
              <div class="mt-8 flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/main" class="inline-flex items-center justify-center rounded-full bg-white px-6 py-3 text-sm font-semibold text-slate-900 shadow hover:bg-slate-100">대시보드 둘러보기</a>
                <a href="${pageContext.request.contextPath}/register" class="inline-flex items-center justify-center rounded-full border border-white/30 px-6 py-3 text-sm font-semibold text-white hover:bg-white/10">무료 회원가입</a>
              </div>
            </div>
            <div class="relative flex-1">
              <div class="absolute -top-6 -left-6 hidden h-24 w-24 rounded-full bg-sky-400/40 blur-3xl lg:block"></div>
              <div class="absolute -bottom-10 -right-10 hidden h-32 w-32 rounded-full bg-purple-400/40 blur-3xl lg:block"></div>
              <div class="relative grid gap-6 md:grid-cols-2">
                <article class="rounded-3xl bg-white/10 p-6 shadow-xl backdrop-blur">
                  <p class="text-xs font-semibold uppercase tracking-wide text-sky-200">맞춤 추천</p>
                  <h3 class="mt-3 text-lg font-semibold">오늘의 취향 리스트</h3>
                  <p class="mt-2 text-sm text-slate-100">기록한 맛집과 유사한 분위기의 신규 장소를 선별해서 추천합니다.</p>
                  <div class="mt-6 space-y-3 text-sm text-slate-200">
                    <div class="flex items-center justify-between rounded-2xl bg-white/5 px-4 py-3"><span>성수 연어한상</span><span class="text-sky-200">예약 가능</span></div>
                    <div class="flex items-center justify-between rounded-2xl bg-white/5 px-4 py-3"><span>망원 파스타바</span><span class="text-sky-200">20분 거리</span></div>
                    <div class="flex items-center justify-between rounded-2xl bg-white/5 px-4 py-3"><span>연남 히든바</span><span class="text-sky-200">팔로우 ★4.8</span></div>
                  </div>
                </article>
                <article class="rounded-3xl bg-white text-slate-900 shadow-xl">
                  <div class="border-b border-slate-200 px-6 py-4">
                    <p class="text-xs font-semibold uppercase tracking-wide text-slate-400">팔로우 피드</p>
                  </div>
                  <div class="space-y-4 px-6 py-6 text-sm">
                    <div>
                      <p class="font-semibold">@foodmate의 새 후기</p>
                      <p class="mt-2 text-slate-600">“주문 즉시 바로 구워주는 파이, 겉바속촉에 진심인 곳입니다.”</p>
                    </div>
                    <div>
                      <p class="font-semibold">@nightowl의 코스</p>
                      <p class="mt-2 text-slate-600">을지로 노가리 → 을지로 골뱅이 → 종로 디저트바</p>
                    </div>
                    <div>
                      <p class="font-semibold">@branch_hq 소식</p>
                      <p class="mt-2 text-slate-600">“이번 주 신메뉴 시식회 예약 오픈했어요!”</p>
                    </div>
                  </div>
                </article>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="bg-white py-16 md:py-20">
        <div class="container mx-auto px-4">
          <div class="grid gap-12 lg:grid-cols-2 lg:items-center">
            <div>
              <p class="text-sm font-semibold uppercase tracking-wide text-sky-600">지금 가입해야 하는 이유</p>
              <h2 class="mt-4 text-3xl font-bold md:text-4xl">성공적인 미팅과 영업을 위한 올인원 도구</h2>
              <p class="mt-4 text-base text-slate-600">일반 사용자에겐 신뢰할 수 있는 취향 추천을, 비즈니스 회원에게는 지점·본사 통합 관리 도구를 제공합니다.</p>
              <div class="mt-8 grid gap-6 sm:grid-cols-2">
                <div class="rounded-2xl border border-slate-200 p-6">
                  <h3 class="text-lg font-semibold">개인 사용자</h3>
                  <ul class="mt-4 space-y-2 text-sm text-slate-600">
                    <li>• 나와 비슷한 입맛의 피드 모아보기</li>
                    <li>• 예약/쿠폰/코스 한 번에 관리</li>
                    <li>• 실패 없는 모임 장소 추천</li>
                  </ul>
                </div>
                <div class="rounded-2xl border border-slate-200 p-6">
                  <h3 class="text-lg font-semibold">비즈니스 회원</h3>
                  <ul class="mt-4 space-y-2 text-sm text-slate-600">
                    <li>• HQ ↔ 지점 알림과 공지 통합</li>
                    <li>• 실시간 리뷰/예약 데이터</li>
                    <li>• MeetERP 연동으로 재고 관리</li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="rounded-3xl bg-slate-50 p-8 shadow-inner">
              <blockquote class="text-lg font-medium text-slate-700">“MEET LOG 덕분에 팀 회식 장소 찾는 시간이 반으로 줄었어요. 추천 리스트가 항상 믿을 만해서 모두 만족합니다.”</blockquote>
              <div class="mt-6 flex items-center gap-4">
                <div class="h-12 w-12 rounded-full bg-sky-100"></div>
                <div>
                  <p class="text-sm font-semibold">박소연 · 스타트업 CX 리더</p>
                  <p class="text-xs text-slate-500">팔로우 피드 누적 128개</p>
                </div>
              </div>
              <div class="mt-8 flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/register" class="inline-flex items-center justify-center rounded-full bg-sky-500 px-6 py-3 text-sm font-semibold text-white shadow hover:bg-sky-600">무료로 시작하기</a>
                <a href="${pageContext.request.contextPath}/service" class="inline-flex items-center justify-center rounded-full border border-slate-200 px-6 py-3 text-sm font-semibold text-slate-700 hover:bg-slate-100">서비스 소개 보기</a>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="bg-gradient-to-r from-sky-600 via-sky-500 to-indigo-500 py-16 text-white md:py-20">
        <div class="container mx-auto px-4">
          <div class="flex flex-col items-center text-center">
            <h2 class="text-3xl font-bold md:text-4xl">지금 바로 MEET LOG로 미식 여정을 시작해보세요</h2>
            <p class="mt-4 max-w-2xl text-base text-sky-100 md:text-lg">회원가입은 무료이며, 언제든지 취향 데이터를 최신 상태로 유지할 수 있습니다. 추천과 예약, 팔로우 네트워크를 한 플랫폼에서 경험하세요.</p>
            <div class="mt-8 flex flex-wrap justify-center gap-4">
              <a href="${pageContext.request.contextPath}/register" class="inline-flex items-center justify-center rounded-full bg-white px-8 py-3 text-sm font-semibold text-slate-900 shadow hover:bg-slate-100">무료 회원가입</a>
              <a href="${pageContext.request.contextPath}/login" class="inline-flex items-center justify-center rounded-full border border-white/50 px-8 py-3 text-sm font-semibold text-white hover:bg-white/10">이미 계정이 있으신가요?</a>
              <a href="${pageContext.request.contextPath}/main" class="inline-flex items-center justify-center rounded-full border border-white/50 px-8 py-3 text-sm font-semibold text-white hover:bg-white/10">경험 미리 보기</a>
            </div>
          </div>
        </div>
      </section>
    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
  </div>
</body>
</html>
