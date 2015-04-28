package by.itechart.flowerty.web.service;

import by.itechart.flowerty.dao.repository.GoodsRepository;
import by.itechart.flowerty.model.Goods;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

/**
 * Created by Катерина on 28.04.2015.
 *
 * Service for manipulating with goods
 */

@Service
public class GoodsService {

    @Autowired
    private GoodsRepository goodsRepository;

    public Page<Goods> getPage(int page, int size) {
        return goodsRepository.findAll(new PageRequest(page, size));
    }
}