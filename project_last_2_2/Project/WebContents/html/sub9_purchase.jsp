<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,my.model.*,my.dao.*,my.util.*,java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>상품정보</title>

<!-- css파일 삽입 위치 -->
<link href="../css/project.css" rel="stylesheet" type="text/css" />
<link href="../css/purchase.css" rel="stylesheet" type="text/css" />
<link href="../css/notice.css" rel="stylesheet" type="text/css" />
</head>

<body>
   <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
   <script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.5.js"></script>
   <div id="wrap">
      <!-- page_header 삽입 위치 -->
      <jsp:include page="../global/page_header.jsp" flush="false" />

      <div class="product_view">
         <%
         int iid = Integer.parseInt(request.getParameter("iid"));
         Connection conn = ConnectionProvider.getConnection();
         Project_Items item = null;
         try {
            Project_ItemsDao dao = new Project_ItemsDao();
            item = dao.selectById(conn, iid);
         } catch (SQLException e) {
         } finally {
            JdbcUtil.close(conn);
         }
         if (item != null) {
         %>
         <c:set var="p" value="<%=item%>" />
         <div class="img">
            <img name="image" src="/Project/downloadImage/${p.image}" width=620px height=620px />
         </div>
         <div class="infoArea">
            <h2>${p.name}</h2>
            <form name="frm" method="post">
               <input type="hidden" name="iid" value="${p.id}" /> <input type="hidden" name="image" value="${p.image}" /> <input type="hidden" name="price" value="${p.price}" />

               <div class="line"></div>

               <table>
                  <tbody>
                     <tr class="price">
                        <th scope="row"><span style="font-size: 16px; color: #008BCC; font-weight: bold;" id="number">판매가</span></th>
                        <td>
                           <input type="number" id="price" value="${p.price}" readonly="readonly">
                           <span style="font-size: 16px; color: #008BCC; font-weight: bold;" id="price">${p.price}원</span> 
                           <span class="df-custom-add"></span>
                        </td>
                     </tr>
                     <tr class="mileage_value_css  xans-record-">
                        <th scope="row"><span style="font-size: 16px; color: #555555;">적립금</span></th>
                        <td><span style="font-size: 12px; color: #555555;"> <span style="font-size: 16px; color: ##555555">${p.price*0.01}원 (1%)</span>
                        </span></td>
                     </tr>
                  </tbody>
               </table>
               <ul border="1" summary="" class="shoppting option">
                  <!-- 추가옵션 -->
                  <!-- 일반옵션 -->
                  <li class="shopping option_1">
                     <ul>
                        <li class="title" scope="row"><i class="so"> </i> 사이즈</li>
                        <li class="content"><select>
                              <option>- [필수] 옵션을 선택해 주세요 -</option>
                              <option>-------------------</option>
                              <option>M</option>
                              <option>L</option>
                              <option>XL</option>
                        </select>
                           <p class="value"></p></li>
                     </ul>
                  </li>
                  <li class="shopping option_1">
                     <ul>
                        <li class="title" name="amount" scope="row"><i class="so"> </i> 수량</li>
                        <li class="content">
                           <td><select id="num" name="amount">
                                 <option value="0">:: 수량 선택 ::</option>
                                 <option value="1">1</option>
                                 <option value="2">2</option>
                                 <option value="3">3</option>
                                 <option value="4">4</option>
                                 <option value="5">5</option>
                           </select></td>
                           <p class="value"></p>
                        </li>
                     </ul>
                  </li>

                  <!-- 파일첨부 옵션 -->
               </ul>
               <div id="totalPrice" class="totalPrice">
                  <strong>TOTAL</strong> : <span class="total"> <strong> <em> <input type="text" id="result" value="" readonly="readonly"> <script type="text/javascript">
                     var num = document.getElementById('num');
                     num.addEventListener('change', function() {
                        var result = document.getElementById('result');
                        var price = document.getElementById('price');
                        result.value = Number(price.value)
                              * Number(this.value);
                     });
                  </script></em>
                  </strong>
                  </span>
               </div>
               <div class="action_button_1">
                  <div class="buy wrap">
                     <input type="button" name="purchase" onclick="service();putPurchase(form);" value="바로 구매하기" class="button purchase"> </a>
                  </div>
                  <div class="cart wrap">
                     <input type="button" name="cart" onclick="service();putCart(form);" value="카트 담기" class="button cart">
                  </div>

               </div>
            </form>
         </div>
         <%
         } else if (item == null) {
         %>
         <div>
            상품이
            <%=item%></div>
         <%
         }
         %>
      </div>

      <!-- 리뷰리스트 삽입 위치 -->
      <jsp:include page="../global/page_reviewlist.jsp" flush="false" />
      <!-- page_footer 삽입 위치 -->
      <jsp:include page="../global/page_footer.jsp" flush="false" />
   </div>

   <script>
      function service() {
         let loginId = "${LOGINID}";
         if (loginId == "") {
            alert("로그인 후 사용하실 수 있습니다");
            location.href = "/Project/html/sub1_loginform.jsp";
            return false;
         } else {
            return true;
         }
      }
      function putCart(frm) {
         var amount = frm.amount.value.trim();
         var id = frm.iid.value.trim();
         var image = frm.image.value.trim();
         if (amount != 0) {
            window.open("sub9_cartview.jsp?iid=" + id + "&amount=" + amount
                  + "&image=" + image, "");
         } else {
            alert("수량을 선택해 주세요");
         }
      }

      function putPurchase(frm) {
         var amount = frm.amount.value.trim();
         var id = frm.iid.value.trim();
         if (amount != 0) {
            window.open("sub9_buynow.jsp?iid=" + id + "&amount=" + amount);
         } else {
            alert("수량을 선택해 주세요");
         }
      }
   </script>
</body>
</html>