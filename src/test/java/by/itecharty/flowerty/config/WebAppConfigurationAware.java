package by.itecharty.flowerty.config;

import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.context.WebApplicationContext;

import by.itechart.flowerty.configuration.ApplicationConfiguration;
import by.itechart.flowerty.configuration.JpaConfiguration;
import by.itechart.flowerty.configuration.WebAppInitializer;
import by.itechart.flowerty.configuration.WebMvcConfiguration;

import javax.inject.Inject;

import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;

@RunWith(SpringJUnit4ClassRunner.class)
@ActiveProfiles("test")
@WebAppConfiguration
@ContextConfiguration(classes = {
        ApplicationConfiguration.class,
        JpaConfiguration.class,
        WebMvcConfiguration.class,
        WebAppInitializer.class
})
public abstract class WebAppConfigurationAware {

    @Inject
    protected WebApplicationContext wac;
    protected MockMvc mockMvc;

    @Before
    public void before() {
        this.mockMvc = webAppContextSetup(this.wac).build();
    }

}