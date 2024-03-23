<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>구매 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script type="text/javascript">
	function fncGetPurchaseList() {
		document.detailForm.submit();
	}

</script>

<!-- 
<script src="https://code.jquery.com/jquery-2.2.4.js" integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI=" crossorigin="anonymous"></script>
<script type="text/javascript">
	
	$( function() {

			$('#modifier1').on('click', function() {
				$(window.parent.frame['rightFrame'].document.location).attr('href', '/purchase/getPurchase?tranNo=${purchase.tranNo }');
			}).css('color', 'blue').on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});

			$('#modifier2').on('click', function() {
				$(window.parent.frame['rightFrame'].document.location).attr('href', '/purchase/updateTranCode?tranNo=${purchase.tranNo }&tranCode=3');
			}).css('color', 'blue').on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
	});
</script>
 -->
 
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<form name="detailForm" action="/purchase/listPurchase" method="post">

<input type="hidden" id="currentPage" name="currentPage" value="${resultPage.currentPage }" />

검색 :: <input type="text" id="searchKeyword" name="searchKeyword" value="${search.searchKeyword }" />

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">구매 목록조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr> 
		<td colspan="11">전체 ${requestScope.resultPage.totalCount } 건수, 현재 ${resultPage.currentPage } 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품ID</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">구매일자</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송현황</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">정보수정</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>

	
	<%-- 반복문을 통해 구매 리스트를 개별로 출력 --%>
	<c:set var="no" value="${resultPage.totalCount - resultPage.pageSize * (resultPage.currentPage -1 ) }" />
	
	<c:forEach var="purchase" items="${requestScope.list }">
		<tr class="ct_list_pop">
			<td align="center">
				${no }
				<c:set var="no" value="${ no-1 }" />
			</td>
			<td></td>
			<td align="left">
				<a href="/product/getProduct?prodNo=${purchase.purchaseProd.prodNo }&menu=search" style="text-decoration:none"><strong>${purchase.purchaseProd.prodNo }</strong></a>
			</td>
			<td></td>
			<td align="left">${purchase.purchaseProd.prodName }</td>
			<td></td>
			<td align="left">${purchase.orderDate }</td>
			<td></td>
			<%-- tran_state_code : "1" = "구매완료", "2" = "배송중", "3" = "배송완료" --%>
			<td align="left">
				<c:if test="${ purchase.tranCode == 1 }">
					현재 구매완료 상태입니다.
				</c:if><c:if test="${ purchase.tranCode == 2 }">
					현재 배송중 입니다. 
				</c:if><c:if test="${ purchase.tranCode == 3 }">
					현재 배송완료 상태 입니다.
				</c:if>
			</td>
			<td></td>
			<td align="left">
				  
				<c:if test="${purchase.tranCode == 1 }">
					<!-- <span id="modifier1">구매 정보 확인 및 수정</span>  -->
					<a href="/purchase/getPurchase?tranNo=${purchase.tranNo }" style="text-decoration: none;"><strong>구매 정보 확인 및 수정</strong></a> 
				</c:if><c:if test="${purchase.tranCode == 2 }">
					<!-- <span id="modifier2">물건 도착 알리기</span>  -->
					<a href="/purchase/updateTranCode?tranNo=${purchase.tranNo }&tranCode=3" style="text-decoration: none;"><strong>물건 도착 알리기</strong></a>   
				</c:if>
			</td>
		</tr>
	</c:forEach>
</table>  

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
	<tr>
		<td align="center">
		
		<jsp:include page="../common/pageNavigator.jsp"></jsp:include>
		  
		</td>
	</tr>
</table>

<!--  페이지 Navigator 끝 -->
</form>

</div>

</body>
</html>