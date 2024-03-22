<%@ page contentType="text/html; charset=EUC-KR" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>열어본 상품 보기</title>
</head>

<body>
	최근 본 상품 목록
<br>
<br>

<c:if test="${ !empty requestScope.histories }">
	<c:set var="historyNo" value="${ historyNo}" />
	<c:set var="i" value="0" />
	<c:forEach var="history" items="${histories }">
			<a href="/product/getProduct?prodNo=${historyNo[i] }&menu=search"	target="rightFrame">${history }</a>
			<br/>
			<c:set var="i" value="${i+1 }" />
	</c:forEach>
</c:if>

</body>
</html>