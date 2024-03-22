package com.model2.mvc.common;

public class Message {

	private String msg;

	public Message() {
		// TODO Auto-generated constructor stub
	}
	
	public Message(String msg) {
		this.msg = msg;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Message [msg=");
		builder.append(msg);
		builder.append("]");
		return builder.toString();
	}
	
	
}
