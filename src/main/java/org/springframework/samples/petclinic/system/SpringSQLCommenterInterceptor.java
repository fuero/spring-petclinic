package org.springframework.samples.petclinic.system;

import com.google.cloud.sqlcommenter.threadlocalstorage.State;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

import org.springframework.web.method.HandlerMethod;

import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class SpringSQLCommenterInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		// This method MUST always return true since we are
		// only grabbing information about the request.

		boolean isHandlerMethod = handler instanceof HandlerMethod;
		if (!isHandlerMethod) {
			// In this case, return promptly since we
			// can't extract details from the handler.
			return true;
		}

		HandlerMethod handlerMethod = (HandlerMethod) handler;
		String actionName = handlerMethod.getMethod().getName();
		String controllerName = handlerMethod.getBeanType().getSimpleName().replace("Controller", "");

		State.Holder.set(State.newBuilder()
			.withControllerName(controllerName)
			.withActionName(actionName)
			.withFramework("spring")
			.build());

		return true;
	}

}
