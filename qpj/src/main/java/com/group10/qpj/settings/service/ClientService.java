package com.group10.qpj.settings.service;

import com.group10.qpj.settings.domain.Client;

import java.util.Map;

public interface ClientService {
    Client selectUserByLoginActAndPwd(Map<String,Object> map);

    int saveRegisterClient(Client client);
}
