<%@ page contentType="text/html; charset=euc-kr" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	<c:if test="${ resultPage.currentPage <= resultPage.pageUnit }">
			◀ 이전
	</c:if>
	<c:if test="${ resultPage.currentPage > resultPage.pageUnit }">
			<a href="javascript:fncGet<c:if test="${requestScope.title == 'user' }">User</c:if><c:if test="${requestScope.title == 'product' }">Product</c:if><c:if test="${requestScope.title == 'purchase' }">Purchase</c:if>List('${ resultPage.beginUnitPage-1}')">◀ 이전</a>
	</c:if>  
	
	<c:forEach var="i"  begin="${resultPage.beginUnitPage}" end="${resultPage.endUnitPage}" step="1">
		<a href="javascript:fncGet<c:if test="${requestScope.title == 'user' }">User</c:if><c:if test="${requestScope.title == 'product' }">Product</c:if><c:if test="${requestScope.title == 'purchase' }">Purchase</c:if>List('${ i }');">${ i }</a>
	</c:forEach>
	
	<c:if test="${ resultPage.endUnitPage >= resultPage.maxPage }">
			이후 ▶
	</c:if>
	<c:if test="${ resultPage.endUnitPage < resultPage.maxPage }">
			<a href="javascript:fncGet<c:if test="${requestScope.title == 'user' }">User</c:if><c:if test="${requestScope.title == 'product' }">Product</c:if><c:if test="${requestScope.title == 'purchase' }">Purchase</c:if>List('${resultPage.endUnitPage+1}')">이후 ▶</a>
	</c:if>