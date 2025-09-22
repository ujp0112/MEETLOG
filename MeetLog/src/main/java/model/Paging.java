package model;

public class Paging {
	private int page;
	private int totalCount;
	private int itemsPerPage;
	private int pagesPerBlock;

	private int totalPage;
	private int startPage;
	private int endPage;
	private boolean prev;
	private boolean next;

	public Paging(int totalCount, int itemsPerPage, int page, int pagesPerBlock) {
		this.totalCount = totalCount;
		this.itemsPerPage = itemsPerPage;
		this.page = page;
		this.pagesPerBlock = pagesPerBlock;

		totalPage = (int) Math.ceil((double) totalCount / itemsPerPage);
		startPage = ((page - 1) / pagesPerBlock) * pagesPerBlock + 1;
		endPage = startPage + pagesPerBlock - 1;

		if (endPage > totalPage) {
			endPage = totalPage;
		}

		prev = startPage > 1;
		next = endPage < totalPage;
	}

	public int getOffset() {
		return (page - 1) * itemsPerPage;
	}

	// --- (Paging 객체의 모든 필드에 대한 Getter/Setter가 필요합니다) ---
	// (Getter만 우선 추가)
	public int getPage() {
		return page;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public int getItemsPerPage() {
		return itemsPerPage;
	}

	public int getPagesPerBlock() {
		return pagesPerBlock;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public int getStartPage() {
		return startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public boolean isPrev() {
		return prev;
	}

	public boolean isNext() {
		return next;
	}
}