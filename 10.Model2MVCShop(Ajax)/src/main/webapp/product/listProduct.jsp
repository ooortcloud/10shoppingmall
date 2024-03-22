<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%--  JSP 페이지에서 JSTL Core 라이브러리를 사용하기 위한 태그 라이브러리 선언 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
<title>상품 관리</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
 
<script type="text/javascript">
	function fncGetProductList(currentPage) {
		console.log("currentPage = " + currentPage);
		document.getElementById("currentPage").value = currentPage;
 	  	document.detailForm.submit();		
	}
	
	function compare() {
		// input 태그값을 가져올 때 더 가독성있는 함수를 사용하여 가져오자.
		// const min = Number(document.getElementById("priceMin").value);
		// const max = Number(document.getElementById("priceMax").value);
		const min = Number(document.querySelector('input[id="priceMin"]').value);
		const max = Number(document.querySelector('input[id="priceMax"]').value);
		
		console.log("min = " + min);
		console.log("max = " + max);
		
		if( (min < 0) || (max > 2147483647) ) {
			alert("입력 범위를 초과하였습니다.");
		}
		
		if(min != 0 && max != 0) {
			if(min >= max) {
				alert("최소값이 최대값 미만이 되도록 작성해주세요.");
				return ;
			}
		}
		fncGetProductList(document.getElementById("currentPage").value );	
	}

</script>

<script src="https://code.jquery.com/jquery-2.2.4.js" integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI=" crossorigin="anonymous"></script>
<script type="text/javascript">

	$( function() {  
		
		$('a').css('text-decoration', 'none');   
	});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm" action="/product/listProduct?menu=${param.menu }" method="post">

<input type="hidden" id="currentPage" name="currentPage" value="${resultPage.currentPage }" />

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
					
						<%-- parameter로 받은 data들은 JSTL의 'param' 내부 객체에서 가져옴 --%>
						<%-- EL 내부에서는 '을 사용해서 감싸도 문자열로 취급함 --%>
						<c:if test="${param.menu == 'manage' }">
							상품 관리
						</c:if><c:if test="${param.menu == 'search' }">
							상품 목록조회
						</c:if>
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>	 
		 <li>상품명 ::  
		 	<input 	 type="text" id="searchKeyword" name="searchKeyword"  value="${search.searchKeyword }" 
							class="ct_input_g" style="width:200px; height:19px" >
		</li>
		 <li>상품가격 :: 
		 	<input type="text" id="priceMin" name="priceMin" value="${search.priceMin }" 
		 				class="ct_input_g" style="width:200px; height:19px">
		 	 ~ 
		 	<input type="text" id="priceMax" name="priceMax" value="${search.priceMax }" 
		 				class="ct_input_g" style="width:200px; height:19px">
		 </li>
		 
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<a href="javascript:compare();">검색</a>
					</td>
					<td width="14" height="23">
				     <img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<hr/>

<c:if test="${ !empty search.priceDESC}">  <!-- 가격 정렬 기능을 클릭한 경우 --> 
	<c:if test="${search.priceDESC == 0 }">
		<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=0"><strong>낮은가격순</strong></a></span>
		<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=1">높은가격순</a></span>
	</c:if><c:if test="${search.priceDESC == 1 }">
		<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=0">낮은가격순</a></span>
		<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=1"><strong>높은가격순</strong></a></span>
	</c:if>
</c:if><c:if test="${empty search.priceDESC}"> <!-- 디폴트 -->
	<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=0">낮은가격순</a></span>
	<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=1">높은가격순</a></span>
</c:if>

 
<hr/>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >전체 ${requestScope.resultPage.totalCount } 건수, 현재 ${resultPage.currentPage } 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td> 
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
	<%-- JSTL에서 로컬변수 선언 가능 --%>
	<c:set var="no" value="${resultPage.totalCount - resultPage.pageSize * (resultPage.currentPage -1 ) }" />
	
		<%-- JSTL에서 index 관리 Collection을 적용한 반복문 사용하기 --%>
		<c:forEach var="product" items="${requestScope.list }">
			<tr class="ct_list_pop">
				<td align="center">${no }</td>
				<c:set var="no" value="${ no-1 }" />
				<td></td>
				<td align="left">
					<a href="/product/getProduct?prodNo=${product.prodNo }&menu=${param.menu}"><strong>${product.prodName }</strong></a>
				</td>
				<td></td>
				<td align="left">${product.price }</td>
				<td></td>
				<td align="left">${product.regDate }</td>
				<td></td>
				<td align="left">
				
					<%-- JSTL에서 참조 변수를 만들어서 사용 가능 --%>
					<c:set var="presentState" value="${product.proTranCode }" />
					<c:if test="${ (empty presentState) || presentState == 0 }">
						판매 중
					</c:if><c:if test="${ presentState != 0}">
						<c:if test="${param.menu == 'manage' }">
							<c:choose>
								<c:when test="${presentState == 1 }">
									<!-- <span id="doDelivary">client에게 배송하기</span>  --> 
									<a id="doDelivery" href='/purchase/updateTranCodeByProd?prodNo=${product.prodNo }&tranCode=2'><strong> client에게 배송하기</strong></a> 
								</c:when><c:when test="${presentState == 2 }">
									배송 중	
								</c:when><c:when test="${presentState == 3 }">
									배송 완료
								</c:when>
							</c:choose>
						</c:if><c:if test="${param.menu == 'search' && !( (empty presentState) || presentState == 0 ) }">
							재고 없음
						</c:if>
					</c:if>
				</c:forEach>
			</td>
		<td></td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
</table>
 
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">		

		   <%-- 하단 페이지 .jsp 모듈을include --%>
		   <jsp:include page="/common/pageNavigator.jsp"></jsp:include>
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->

</form>

</div>
</body>
</html>
