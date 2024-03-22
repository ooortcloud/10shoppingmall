<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%--  JSP ���������� JSTL Core ���̺귯���� ����ϱ� ���� �±� ���̺귯�� ���� --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
<title>��ǰ ����</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
 
<script type="text/javascript">
	function fncGetProductList(currentPage) {
		console.log("currentPage = " + currentPage);
		document.getElementById("currentPage").value = currentPage;
 	  	document.detailForm.submit();		
	}
	
	function compare() {
		// input �±װ��� ������ �� �� �������ִ� �Լ��� ����Ͽ� ��������.
		// const min = Number(document.getElementById("priceMin").value);
		// const max = Number(document.getElementById("priceMax").value);
		const min = Number(document.querySelector('input[id="priceMin"]').value);
		const max = Number(document.querySelector('input[id="priceMax"]').value);
		
		console.log("min = " + min);
		console.log("max = " + max);
		
		if( (min < 0) || (max > 2147483647) ) {
			alert("�Է� ������ �ʰ��Ͽ����ϴ�.");
		}
		
		if(min != 0 && max != 0) {
			if(min >= max) {
				alert("�ּҰ��� �ִ밪 �̸��� �ǵ��� �ۼ����ּ���.");
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
					
						<%-- parameter�� ���� data���� JSTL�� 'param' ���� ��ü���� ������ --%>
						<%-- EL ���ο����� '�� ����ؼ� ���ε� ���ڿ��� ����� --%>
						<c:if test="${param.menu == 'manage' }">
							��ǰ ����
						</c:if><c:if test="${param.menu == 'search' }">
							��ǰ �����ȸ
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
		 <li>��ǰ�� ::  
		 	<input 	 type="text" id="searchKeyword" name="searchKeyword"  value="${search.searchKeyword }" 
							class="ct_input_g" style="width:200px; height:19px" >
		</li>
		 <li>��ǰ���� :: 
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
						<a href="javascript:compare();">�˻�</a>
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

<c:if test="${ !empty search.priceDESC}">  <!-- ���� ���� ����� Ŭ���� ��� --> 
	<c:if test="${search.priceDESC == 0 }">
		<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=0"><strong>�������ݼ�</strong></a></span>
		<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=1">�������ݼ�</a></span>
	</c:if><c:if test="${search.priceDESC == 1 }">
		<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=0">�������ݼ�</a></span>
		<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=1"><strong>�������ݼ�</strong></a></span>
	</c:if>
</c:if><c:if test="${empty search.priceDESC}"> <!-- ����Ʈ -->
	<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=0">�������ݼ�</a></span>
	<span style="font-size: 12px;"><a href="?menu=${param.menu}&priceDESC=1">�������ݼ�</a></span>
</c:if>

 
<hr/>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td colspan="11" >��ü ${requestScope.resultPage.totalCount } �Ǽ�, ���� ${resultPage.currentPage } ������</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">��ǰ��</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">����</td> 
		<td class="ct_line02"></td>
		<td class="ct_list_b">�����</td>	
		<td class="ct_line02"></td>
		<td class="ct_list_b">�������</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
	<%-- JSTL���� ���ú��� ���� ���� --%>
	<c:set var="no" value="${resultPage.totalCount - resultPage.pageSize * (resultPage.currentPage -1 ) }" />
	
		<%-- JSTL���� index ���� Collection�� ������ �ݺ��� ����ϱ� --%>
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
				
					<%-- JSTL���� ���� ������ ���� ��� ���� --%>
					<c:set var="presentState" value="${product.proTranCode }" />
					<c:if test="${ (empty presentState) || presentState == 0 }">
						�Ǹ� ��
					</c:if><c:if test="${ presentState != 0}">
						<c:if test="${param.menu == 'manage' }">
							<c:choose>
								<c:when test="${presentState == 1 }">
									<!-- <span id="doDelivary">client���� ����ϱ�</span>  --> 
									<a id="doDelivery" href='/purchase/updateTranCodeByProd?prodNo=${product.prodNo }&tranCode=2'><strong> client���� ����ϱ�</strong></a> 
								</c:when><c:when test="${presentState == 2 }">
									��� ��	
								</c:when><c:when test="${presentState == 3 }">
									��� �Ϸ�
								</c:when>
							</c:choose>
						</c:if><c:if test="${param.menu == 'search' && !( (empty presentState) || presentState == 0 ) }">
							��� ����
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

		   <%-- �ϴ� ������ .jsp �����include --%>
		   <jsp:include page="/common/pageNavigator.jsp"></jsp:include>
    	</td>
	</tr>
</table>
<!--  ������ Navigator �� -->

</form>

</div>
</body>
</html>
