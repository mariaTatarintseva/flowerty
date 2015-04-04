package by.itecharty.flowerty.dao.repository;

import by.itechart.flowerty.dao.repository.PhoneRepository;
import by.itechart.flowerty.model.Contact;
import by.itechart.flowerty.model.Phone;
import by.itecharty.flowerty.config.JpaConfigurationAware;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

/**
 * Created with IntelliJ IDEA.
 * User: Мария
 * Date: 31.03.15
 * Time: 11:25
 * To change this template use File | Settings | File Templates.
 */
@Ignore
public class TestPhoneRepository extends JpaConfigurationAware {
    @Autowired
    private PhoneRepository phoneRepository;
    @Test
    public void savePhone_ValidPhones_ReturnsPageOfPhones() {
        Phone phone = new Phone();
        phone.setNumber("1232121");
        phone.setCountry("375");
        Contact contact = new Contact();
        contact.setId(1l);
        phone.setContact(contact);
        phone.setComment("PhoneComment");
        phoneRepository.save(phone);
    }
    @Test
    public void findPhone_ValidId_ReturnsPhone() {
        Phone phone = phoneRepository.findOne(1l);
        Assert.assertEquals(phone.getContact().getName(), "TestName");
        Assert.assertEquals(phone.getNumber(), "1232121");
    }
    @Test
    public void findPhone_InvalidId_ReturnsNull() {
        Phone phone = phoneRepository.findOne(1000l);
        Assert.assertNull(phone);
    }
    @Test
    public void findPhones_ValidContact_ReturnsPageOfPhones() {
        Contact contact = new Contact();
        contact.setId(1l);
        Page<Phone> phones = phoneRepository.findByContact(contact, new PageRequest(0, 10));
        Assert.assertEquals(phones.getContent().get(0).getNumber(), "1232121");
        Assert.assertEquals(phones.getContent().get(0).getContact().getName(), "TestName");
    }
    @Test
    public void findPhones_InvalidContact_ReturnsEmptyPage() {
        Contact contact = null;
        Page<Phone> phones = phoneRepository.findByContact(contact, new PageRequest(0, 10));
        Assert.assertEquals(phones.getContent().size(), 0);
    }
}