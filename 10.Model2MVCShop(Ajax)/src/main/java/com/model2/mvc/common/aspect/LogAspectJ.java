package com.model2.mvc.common.aspect;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;

/*
 * FileName : PojoAspectJ.java
 *	:: XML 에 선언적으로 aspect 의 적용   
  */
public class LogAspectJ {

	///Constructor
	public LogAspectJ() {
		System.out.println("\nCommon :: "+this.getClass()+" default constructor...\n");
	}
	
	//Around  Advice
	public Object invoke(ProceedingJoinPoint joinPoint) throws Throwable {
			
		System.out.println("");
		System.out.println("[Around before] target object's method :: "+
													joinPoint.getTarget().getClass().getSimpleName() +"."+
													joinPoint.getSignature().getName());
		if(joinPoint.getArgs().length !=0){
			System.out.println("[Around before] method에 전달되는 argument 개수 = " + joinPoint.getArgs().length);
			// array를 List로 변경하여 toString() 사용
			System.out.println("[Around before] method에 전달되는 argument :: " + Arrays.asList(joinPoint.getArgs()) ); 
		}
		//==> 타겟 객체의 Method 를 호출 하는 부분 
		System.out.println(getClass().getSimpleName() +" :: target  object's  method proceed... ");
		Object obj = joinPoint.proceed();

		System.out.println("[Around after] '"+joinPoint.getTarget().getClass().getSimpleName() +"."+joinPoint.getSignature().getName()+"' return value = "+obj);
		System.out.println("");
		
		return obj;
	}
	
	// Spring AOP는 constructor 메소드에 관여하지 못한다...
	/*
	public void logConstructor(ProceedingJoinPoint joinPoint) throws Throwable {
		System.out.println(getClass().getSimpleName() + " default constructor...");
		joinPoint.proceed();
	}
	*/
	
}//end of class