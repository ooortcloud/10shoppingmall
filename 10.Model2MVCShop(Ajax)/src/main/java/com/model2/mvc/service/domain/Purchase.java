package com.model2.mvc.service.domain;


import java.sql.Date;

public class Purchase {
	
	private User buyer;   // buyer_id
	private String divyAddr;   // demailaddr
	private String divyDate;  // dlvy_date
	private String divyRequest;   // dlvy_request
	private Date orderDate;  // order_data
	private String paymentOption;  // payment_option
	private Product purchaseProd;  // prod_no
	private String receiverName;  // receiver_name
	private String receiverPhone;  // receiver_phone
	private String tranCode;  // tran_status_code (1~3)
	private Integer tranNo;  // tran_no 
	
	public Purchase(){
	}
	
	public User getBuyer() {
		return buyer;
	}
	public void setBuyer(User buyer) {
		this.buyer = buyer;
	}
	public String getDivyAddr() {
		return divyAddr;
	}
	public void setDivyAddr(String divyAddr) {
		this.divyAddr = divyAddr;
	}
	public String getDivyDate() {
		return divyDate;
	}
	public void setDivyDate(String divyDate) {
		this.divyDate = divyDate;
	}
	public String getDivyRequest() {
		return divyRequest;
	}
	public void setDivyRequest(String divyRequest) {
		this.divyRequest = divyRequest;
	}
	public Date getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}
	public String getPaymentOption() {
		return paymentOption;
	}
	public void setPaymentOption(String paymentOption) {
		this.paymentOption = paymentOption;
	}
	public Product getPurchaseProd() {
		return purchaseProd;
	}
	public void setPurchaseProd(Product purchaseProd) {
		this.purchaseProd = purchaseProd;
	}
	public String getReceiverName() {
		return receiverName;
	}
	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}
	public String getReceiverPhone() {
		return receiverPhone;
	}
	public void setReceiverPhone(String receiverPhone) {
		this.receiverPhone = receiverPhone;
	}
	public String getTranCode() {
		return tranCode;
	}
	public void setTranCode(String tranCode) {
		this.tranCode = tranCode;
	}
	public int getTranNo() {
		return tranNo;
	}
	public void setTranNo(Integer tranNo) {
		this.tranNo = tranNo;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Purchase [buyer=");
		builder.append(buyer);
		builder.append(", divyAddr=");
		builder.append(divyAddr);
		builder.append(", divyDate=");
		builder.append(divyDate);
		builder.append(", divyRequest=");
		builder.append(divyRequest);
		builder.append(", orderDate=");
		builder.append(orderDate);
		builder.append(", paymentOption=");
		builder.append(paymentOption);
		builder.append(", purchaseProd=");
		builder.append(purchaseProd);
		builder.append(", receiverName=");
		builder.append(receiverName);
		builder.append(", receiverPhone=");
		builder.append(receiverPhone);
		builder.append(", tranCode=");
		builder.append(tranCode);
		builder.append(", tranNo=");
		builder.append(tranNo);
		builder.append("]");
		return builder.toString();
	}
}