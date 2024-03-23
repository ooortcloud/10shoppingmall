<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
	<meta charset="EUC-KR">
	
	<title>Model2 MVC Shop</title>

	<link href="/css/left.css" rel="stylesheet" type="text/css">
	
	<!-- CDN(Content Delivery Network) 호스트 사용 -->
	<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
	<script type="text/javascript">
	    
		/*  이 function을 jQuery에서 인식하지 못함... 
		function history(){
			popWin = window.open("/history.jsp",
														"popWin",
														"left=300, top=200, width=300, height=200, marginwidth=0, marginheight=0, scrollbars=no, scrolling=no, menubar=no, resizable=no");
		}
		*/
	
		//==> jQuery 적용 추가된 부분
		 $(function() {
			 

			 
			//==> 개인정보조회 Event 연결처리부분
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
		 	$( ".Depth03:contains('개인정보조회')" ).on("click" , function() {
				//Debug..
				//alert(  $( ".Depth03:contains('개인정보조회')" ).html() );
				$(window.parent.frames["rightFrame"].document.location).attr("href","/user/getUser?userId=${user.userId}");
			}).on('mouseover', function() {
				 $(this).css('cursor', 'pointer');
			 }).on('mouseout', function() {
				$(this).css('cursor', 'default');   
			 });
			
			
			//==> 회원정보조회 Event 연결처리부분
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
		 	$( ".Depth03:contains('회원정보조회')" ).on("click" , function() {
				//Debug..
				//alert(  $( ".Depth03:contains('회원정보조회')" ) );
		 		$(window.parent.frames["rightFrame"].document.location).attr("href","/user/listUser");
			}).on('mouseover', function() {
				 $(this).css('cursor', 'pointer');
			 }).on('mouseout', function() {
				$(this).css('cursor', 'default');        
			 });
			
			
			$('.Depth03:contains("판매상품등록")').on('click', function() {
				//alert(  $( ".Depth03:contains('판매상품등록')" ).html().trim() );   
				$(window.parent.frames["rightFrame"].document.location).attr('href', '/product/addProduct');
			}).on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
			
			
			$('.Depth03:contains("판매상품관리")').on('click', function() { 
				//alert(  $( ".Depth03:contains('판매상품관리')" ).html().trim() );   
				$(window.parent.frames['rightFrame'].document.location).attr('href', '/product/listProduct/manage');
			}).on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
			
			  
			$('.Depth03:contains("상 품 검 색")').on('click', function() {
				//alert(  $( ".Depth03:contains('상 품 검 색')" ).html().trim() );   
				$(window.parent.frames['rightFrame'].document.location).attr('href', '/product/listProduct/search'); 
			}).on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
			
			
			$('.Depth03:contains("구매이력조회")').on('click', function() {
				//alert(  $( ".Depth03:contains('구매이력조회')" ).html().trim() );   
				$(window.parent.frames['rightFrame'].document.location).attr('href', '/purchase/listPurchase');
			}).on('mouseover', function() {  
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
			
			     
			$('.Depth03:contains("최근 본 상품")').on('click', function() {
				// alert(  $( ".Depth03:contains('최근 본 상품')" ).html().trim() );   
				// $(window.parent.frames['rightFrame'].document.location).attr('href', 'javascript:history()');
				window.open("/util/history",
						"popWin",
						"left=300, top=200, width=300, height=200, marginwidth=0, marginheight=0, scrollbars=no, scrolling=no, menubar=no, resizable=no");
			}).on('mouseover', function() {
				$(this).css('cursor', 'pointer');
			}).on('mouseout', function() {
				$(this).css('cursor', 'default');
			});
		});	

	</script>
	
</head>

<body background="/images/left/imgLeftBg.gif" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  >

<table width="159" border="0" cellspacing="0" cellpadding="0">

<!--menu 01 line-->
<tr>
	<td valign="top"> 
		<table  border="0" cellspacing="0" cellpadding="0" width="159" >	
			<tr>
				<c:if test="${ !empty user }">
					<tr>
						<td class="Depth03">
							<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
							<a href="/user/getUser?userId=${user.userId}" target="rightFrame">개인정보조회</a>	
							////////////////////////////////////////////////////////////////////////////////////////////////// -->
							개인정보조회
						</td>
					</tr>
				</c:if>
			
				<c:if test="${user.role == 'admin'}">
					<tr>
						<td class="Depth03" >
							<!-- ////////////////// jQuery Event 처리로 변경됨 ///////////////////////// 
							<a href="/user/listUser" target="rightFrame">회원정보조회</a>	
							////////////////////////////////////////////////////////////////////////////////////////////////// -->
							회원정보조회
						</td>
					</tr>
				</c:if>
			
				<tr>
					<td class="DepthEnd">&nbsp;</td>
				</tr>
		</table>
	</td>
</tr>

<!--menu 02 line-->
<c:if test="${user.role == 'admin'}">
	<tr>
		<td valign="top"> 
			<table  border="0" cellspacing="0" cellpadding="0" width="159">
				<tr>
					<td class="Depth03">
						판매상품등록
					</td>
				</tr>
				<tr>
					<td class="Depth03"> 
						판매상품관리
					</td>
				</tr>
				<tr>
					<td class="DepthEnd">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
</c:if>

<!--menu 03 line-->
<tr>
	<td valign="top"> 
		<table  border="0" cellspacing="0" cellpadding="0" width="159">
			<tr>
				<td class="Depth03">
					상 품 검 색
				</td>
			</tr>
			
			<c:if test="${ !empty user && user.role == 'user'}">
			<tr>
				<td class="Depth03">
					구매이력조회
				</td>
			</tr>
			</c:if>
			
			<tr>
				<td class="DepthEnd">&nbsp;</td>
			</tr>
			<tr>
				<td class="Depth03">최근 본 상품</td>
			</tr>
		</table>
	</td>
</tr>

</table>

</body>

</html>