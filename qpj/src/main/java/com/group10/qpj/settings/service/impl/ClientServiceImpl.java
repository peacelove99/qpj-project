package com.group10.qpj.settings.service.impl;

import com.group10.qpj.settings.domain.Client;
import com.group10.qpj.settings.mapper.ClientMapper;
import com.group10.qpj.settings.service.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service("clientService")
public class ClientServiceImpl implements ClientService {

    @Autowired
    private ClientMapper clientMapper;

    @Override
    public Client selectUserByLoginActAndPwd(Map<String, Object> map) {
        return clientMapper.selectUserByLoginActAndPwd(map);
    }
}
