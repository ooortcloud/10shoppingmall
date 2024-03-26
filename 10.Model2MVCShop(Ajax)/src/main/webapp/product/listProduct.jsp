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

<!-- jQuery core library 외에도 다양한 library 추가해야 함 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.12.4.js"></script>
<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script> 
<script type="text/javascript">

	$( function() {  
		
		$('a').css('text-decoration', 'none');   
		
		$('.ct_btn01:contains("검색")').on('click', function() {
			compare();
		}).on('mouseover', function() {
			$('.ct_btn01:contains("검색")').css('cursor', 'pointer');
		}).on('mouseout', function() {
			$('.ct_btn01:contains("검색")').css('cursor', 'default');
		});
	});
	
	$( function() { 
		
		const inputKeyword = $('#searchKeyword');
		
		inputKeyword.on('click', function() {  // 첫 입력 버그 제거용
			
			console.log('searchKeyword 입력 대기...');
		});
		
		inputKeyword.on('keyup', function(event) {  // 사용자가 글자를 입력했을 때 :: event를 통해 다양한 정보 주입받기 가능

			/// 실질적인 문자 입력이 아닌 경우 request 안 보냄.
			// keyCode :: ASCII code value
			console.log("flag = " + event.keyCode);
			if( event.keyCode <= 31 ) {
				return ;
			}
		
			$.ajax( {
				 
				url : "/rest/product/json/listProduct/autocomplete",
				method : "POST",
				dataType : "JSON",
				headers : {
					"Accept" : "application/json",
					"Content-Type" : "application/json"
				},
				/*
					JSON 객체 :: query string으로 올려 보냄  << URL에 의존적  @ModelAttribute
					JSON string :: body에 그대로 담겨서 보냄  @RequestBody
				*/
				data : JSON.stringify( {
					searchKeyword : inputKeyword.val(),
					priceMin : $('#priceMin').val(),
					priceMax : $('#priceMax').val(),
					currentPage : "1" 
				}),   
				success : function(responseBody, httpStatus) {
					
					console.log("server data 수신")
					const arr = new Array();
					// JSON array object로부터 필요한 data만 추출해서 array 생성
					for (const item of responseBody.list) { 
						arr.push(item.prodName); 
					}
					if(responseBody != null) { 
						
						console.log(arr); 

						// 현재 page 첫 load 시 첫 글자 입력 시 활성화가 안 되는 버그 존재...
						inputKeyword.autocomplete({ 
							
							source: arr,  // 검색 결과
							/*
								callback
								event :: 현재 작동한 event listener (추측)
								ui :: 현재 사용 중인 jQuery object
							*/
							select: function(event, ui) {  // callback :: 사용자가 추천 검색어를 클릭했을 때
								
								inputKeyword.autocomplete('close');  // select 후 추천 검색 리스트 자동 닫기
								console.log("list 재구성에 필요한 data load...")
								$.ajax( { 
									
									url : "/rest/product/json/listProduct/search",
									method : "POST",
									dataType : "json",
									headers: { 
										"Accept" : "application/json",
										"Content-Type" : "application/json"
									},
									data: JSON.stringify({
										currentPage : "1",
										// searchKeyword : inputKeyword.val()
										searchKeyword : ui.item.value
									}),
									// 기존 UI를 재사용하자...
									success: function(responseBody, httpStatus) {

										console.log("list 재구성...")
										const searchTable = $('#searchTable');
										searchTable.empty();  // 기존 list 전부 지운다.
										
										//  list 개수만큼 반복해서 append하면 됨...
										let num = responseBody.resultPage.totalCount;
										const menu = $('#menu').val();
										// JSTL을 사용하면 사용자의 event에 따라 동적으로 화면 전환이 불가능...
										searchTable.append("<tr><td colspan='11' >전체 "+responseBody.resultPage.totalCount+" 건수, 현재 "+responseBody.resultPage.currentPage+" 페이지</td></tr>");
										
										/// table column name list
										let temp = "";  
										temp = "<tr><td class='ct_list_b' width='100'>No</td>"
													+"<td class='ct_line02'></td>"
													+'<td class="ct_list_b" width="150">상품명</td>'
													+'<td class="ct_line02"></td>'
													+'<td class="ct_list_b" width="150">가격</td>'
													+'<td class="ct_line02"></td>'
													+'<td class="ct_list_b">등록일</td>'
													+'<td class="ct_line02"></td>'
													+'<td class="ct_list_b">현재상태</td></tr>'
													+"</tr>";
										searchTable.append(temp);
										searchTable.append('<tr><td colspan="11" bgcolor="808285" height="1"></td></tr>\n\n\n');
										
										/// table row
										temp="";
										for(const item of responseBody.list) { 
											temp += "<tr class='ct_list_pop'>\n"
											temp += "<td align='center'>"+num+"</td>\n";
											num--;
											temp += "<td></td>\n";
											temp += "<td align='left'>\n";
											temp += "<a style='text-decoration:none' href='/product/getProduct?prodNo="+item.prodNo+"&menu="+menu+"'><strong>"+item.prodName+"</strong></a>\n";
											temp += "</td>\n"
											temp +=  "<td></td>\n";
											temp += "<td align='left'>"+item.price+"</td>\n";
											temp += "<td></td>\n";
											temp += "<td align='left'>"+new Date(item.regDate).toLocaleDateString()+"</td>\n";  // Date 형식에 맞게 변환 필요
											temp += "<td></td>\n";
											temp += "<td align='left'>\n";
											
											let presentState = item.proTranCode;
											if(presentState == null || presentState == 0) {
												temp += "판매 중";
											} else {
												if(menu == "manage") {
													switch(presentState) {
														case 1:
															temp += "<a id='doDelivery' href='/purchase/updateTranCodeByProd?prodNo="+item.prodNo+"&tranCode=2'><strong> client에게 배송하기</strong></a>";
															break;
														case 2:
															temp += "배송 중";
															break;
														case 3:
															temp += "배송 완료";
															break;
													}
												} else {
													temp += "재고 없음";
												}
											}
											
											temp += '</td></tr>'; 
										}  /// for end
										
										temp += '<tr><td colspan="11" bgcolor="D6D7D6" height="1"></td></tr>';
										searchTable.append(temp);
										
										/// page navigator
										temp="";
										const pageNavigator = $('td#pageNavigator');
										pageNavigator.empty();  // navigator 초기화
										if(responseBody.resultPage.currentPage <= responseBody.resultPage.pageUnit) {
											temp += "◀ 이전";
										} else {
											temp += "<a href='javascript:fncGetProductList("+(responseBody.resultPage.beginUnitPage - 1)+")'>◀ 이전</a>";
										}
										temp += " ";
										console.log("beginUnitPage :: " + responseBody.resultPage.beginUnitPage);
										console.log("endUnitPage :: " + responseBody.resultPage.endUnitPage);
										for(let i = responseBody.resultPage.beginUnitPage; i < responseBody.resultPage.endUnitPage + 1; i++ ) {
											temp += "<a href='javascript:fncGetProductList("+i+")'>"+i+"</a>";
											temp += " ";
										}
										
										console.log("maxPage :: " + responseBody.resultPage.maxPage);
										if(responseBody.resultPage.endUnitPage >= responseBody.resultPage.maxPage) {
											temp += "이후 ▶";
										} else {
											temp += "<a href='javascript:fncGetProductList("+(responseBody.resultPage.endUnitPage + 1)+")'>이후 ▶</a>";
										}
										pageNavigator.append(temp);
									}
								});
							}
						});  /// autocomplete callback end
					} else { // if( responseBody === null )
						$('#searchKeyword').autocomplete( 'destroy');
					}
				}  /// success end
			} );  /// ajax end
		});  /// keyup callback end
	});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;"> 

<form name="detailForm" action="/product/listProduct/${menu }" method="post">

<input type="hidden" id="currentPage" name="currentPage" value="${resultPage.currentPage }" />
<input type="hidden" id="menu" name="menu" value="${menu }" />
<input type="hidden" id='priceDESC' name="priceDESC" value="${search.priceDESC}" />

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
						<c:if test="${menu == 'manage' }">
							상품 관리
						</c:if><c:if test="${menu == 'search' }">
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
						검색
						<!-- <a href="javascript:compare();">검색</a>  -->
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

 <!-- 가격 정렬 기능을 클릭한 경우 -->
<c:if test="${ !empty search.priceDESC}">  
	<!-- 입력한 조건 box에 따라 query string 동적 구현 -->
	<c:if test="${search.priceDESC == 0 }">
		<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>"><strong>낮은가격순</strong></a></span>
		<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">높은가격순</a></span>
	</c:if><c:if test="${search.priceDESC == 1 }">
		<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">낮은가격순</a></span>
		<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>"><strong>높은가격순</strong></a></span>
	</c:if>
</c:if><c:if test="${empty search.priceDESC}"> <!-- 디폴트 --> 
	<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=0<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">낮은가격순</a></span>
	<span style="font-size: 12px;"><a href="/product/listProduct/${menu}?priceDESC=1<c:if test='${ !empty search.searchKeyword }'>&searchKeyword=${search.searchKeyword }</c:if><c:if test='${ !empty search.priceMin }'>&priceMin=${search.priceMin }</c:if><c:if test='${ !empty search.priceMax }'>&priceMax=${search.priceMax }</c:if>">높은가격순</a></span>
</c:if> 

 
<hr/>
<table id="searchTable" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
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
			<a href="/product/getProduct?prodNo=${product.prodNo }&menu=${menu}"><strong>${product.prodName }</strong></a>
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
				<c:if test="${menu == 'manage' }">
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
				</c:if><c:if test="${menu == 'search' && !( (empty presentState) || presentState == 0 ) }">
					재고 없음
				</c:if>
			</c:if>
		</td>
	</c:forEach>
		<td></td>
	</tr> 
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
</table>
 
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td id="pageNavigator" align="center">		

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
