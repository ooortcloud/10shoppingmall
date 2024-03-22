package com.model2.mvc.common;


//==>리스트화면을 모델링(추상화/캡슐화)한 Bean 
public class Search {
	
	///Field
	private int currentPage;
	private String searchKeyword;
	private int pageSize;
	// for 회원
	private String searchCondition;  // 검색 타입
	// for 상품
	private String priceDESC;  // "1"=가격높은순, "0"=가격낮은순, null=비활성화
	private Integer priceMin;  // 최저가
	private Integer priceMax;  // 최고가
	
	//==> 리스트화면 currentPage에 해당하는 회원정보를 ROWNUM 사용 SELECT 위해 추가된 Field 
	//==> UserMapper.xml 의 
	//==> <select  id="getUserList"  parameterType="search"	resultMap="userSelectMap">
	//==> 참조
	private int endRowNum;
	private int startRowNum;
	
	///Constructor
	public Search() {
	}
	
	///Method
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int paseSize) {
		this.pageSize = paseSize;
	}
	
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public String getSearchCondition() {
		return searchCondition;
	}
	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}
	
	public String getSearchKeyword() {
		return searchKeyword;
	}
	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}
	
	public String getPriceDESC() {
		return priceDESC;
	}

	public void setPriceDESC(String priceDESC) {
		this.priceDESC = priceDESC;
	}

	public Integer getPriceMin() {
		return priceMin;
	}

	public void setPriceMin(Integer priceMin) {
		this.priceMin = priceMin;
	}

	public Integer getPriceMax() {
		return priceMax;
	}

	public void setPriceMax(Integer priceMax) {
		this.priceMax = priceMax;
	}

	/// getter를 변형하여 get값을 변경시킬 수 있다!
	//==> Select Query 시 ROWNUM 마지막 값 
	public int getEndRowNum() {
		System.out.println("getEndRowNum()");    
		return getCurrentPage()*getPageSize();
	}
	//==> Select Query 시 ROWNUM 시작 값
	public int getStartRowNum() {
		System.out.println("getStartRowNum()");
		return (getCurrentPage()-1)*getPageSize()+1;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Search [currentPage=");
		builder.append(currentPage);
		builder.append(", searchKeyword=");
		builder.append(searchKeyword);
		builder.append(", pageSize=");
		builder.append(pageSize);
		builder.append(", searchCondition=");
		builder.append(searchCondition);
		builder.append(", priceDESC=");
		builder.append(priceDESC);
		builder.append(", priceMin=");
		builder.append(priceMin);
		builder.append(", priceMax=");
		builder.append(priceMax);
		builder.append(", endRowNum=");
		builder.append(endRowNum);
		builder.append(", startRowNum=");
		builder.append(startRowNum);
		builder.append("]");
		return builder.toString();
	}
}