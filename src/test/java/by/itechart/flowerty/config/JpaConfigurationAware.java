package by.itechart.flowerty.config;

import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.junit.runner.RunWith;

import by.itechart.flowerty.configuration.ApplicationConfiguration;
import by.itechart.flowerty.configuration.JpaConfiguration;

/**
 * @author Eugene Putsykovich(slesh) Mar 26, 2015
 *
 *         Configuration for testing Jpa repositories
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = { 
	ApplicationConfiguration.class,
	JpaConfiguration.class })
public class JpaConfigurationAware {

}
