package by.itecharty.flowerty.web.controller;

import by.itechart.flowerty.dao.repository.UserRepository;
import by.itechart.flowerty.model.User;
import by.itechart.flowerty.web.controller.SigninController;
import by.itecharty.flowerty.config.MockTestConfigigurationAware;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * @author Eugene Putsykovich(slesh) Mar 26, 2015
 * 
 *         Test for SiginController
 */
public class TestSigninController extends MockTestConfigigurationAware {
	@Mock
	private UserRepository userRepositoryMock;

	@InjectMocks
	private SigninController signinControllerMock;

	private MockMvc mock;

	@Before
	public void setUp() {
		mock = MockMvcBuilders.standaloneSetup(signinControllerMock)
				.setHandlerExceptionResolvers(withExceptionControllerAdvice())
				.build();
	}

	@Test
	public void signin_ShouldReturnViewNameForSignin() throws Exception {
		mock
			.perform(get("/signin"))
			.andExpect(status().isOk())
			.andExpect(forwardedUrl("signin/signin"));			
	}
	
	@Test
	public void signin_PassValidLoginAndPassword_ShouldAuthenticate() throws Exception{
		User existsUser = TestControllerHelper.buildValidShortUserForTest();
		
		when(userRepositoryMock.findUserByLoginAndPassword(existsUser.getLogin(), existsUser.getPassword()))
			.thenReturn(existsUser);
		
		mock
			.perform(post("/signin")
					.contentType(TestControllerHelper.APPLICATION_JSON_UTF8)
					.content(TestControllerHelper.convertObjectToJsonBytes(existsUser))
					)
			.andExpect(status().isOk())
			.andExpect(forwardedUrl("home/index"));
	
		verify(userRepositoryMock, times(1))
			.findUserByLoginAndPassword(existsUser.getLogin(), existsUser.getPassword());
		verifyNoMoreInteractions(userRepositoryMock);
	}
	
	@Test
	public void signin_PassInvalidLoginAndPassword_NotAuthenticateShouldRedirectToSigninPage() throws Exception{
		User notExistsUser = TestControllerHelper.buildInvalideShordUserForTest();
		
		when(userRepositoryMock.findUserByLoginAndPassword(notExistsUser.getLogin(), notExistsUser.getPassword()))
			.thenReturn(null);
		
		mock
			.perform(post("/signin")
					.contentType(TestControllerHelper.APPLICATION_JSON_UTF8)
					.content(TestControllerHelper.convertObjectToJsonBytes(notExistsUser))
					)
			.andExpect(status().isOk())
			.andExpect(forwardedUrl("signin/signin"));
	
		verify(userRepositoryMock, times(1))
			.findUserByLoginAndPassword(notExistsUser.getLogin(), notExistsUser.getPassword());
		verifyNoMoreInteractions(userRepositoryMock);
	}
}
