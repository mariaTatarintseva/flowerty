package by.itechart.flowerty.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import by.itechart.flowerty.web.service.UserService;

/**
 * @author Eugene Putsykovich(slesh) Mar 24, 2015
 *
 *         Signin handler
 */
@Controller
public class SigninController {
	private Logger LOGGER = LoggerFactory.getLogger(SigninController.class);
	
	@Autowired
	private UserService userService;
	
	@RequestMapping(value = "login", method = RequestMethod.GET)
	public String login(@RequestParam(value = "logout", required = false) String logout, HttpServletRequest request) {
		LOGGER.info("move to login page");

		if (logout != null) {
			LOGGER.info("logout user");
		}

		return "signin/signin";
	}
	
	@RequestMapping(value = "login", method = RequestMethod.POST)
	public String signin(@RequestParam("login") String login, @RequestParam("password") String password) {
		LOGGER.info("try signin user with login: {} and password: {}", login, password);

		boolean isExist = (userService.findUserByLoginAndPassword(login, password) != null);

		if (isExist) {
			LOGGER.info("success. redirect to home/index page");
			return "home/index";
		} else {
			LOGGER.info("unsuccess. redirect to back: signin/signin");
			return "signin/signin";
		}
	}
}
