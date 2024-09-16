-- Cliente 1
INSERT INTO clientes (nome, cpf, email, telefone, data_criacao)
VALUES ('Cliente X', '12345678900', 'clientex@exemplo.com', '+5511987654321', CURRENT_TIMESTAMP);

INSERT INTO linhas_moveis (id_cliente, numero_linha, plano, status, data_inicio, data_fim, data_criacao)
VALUES (1, '+5511987654321', 'Vivo Pós 20GB', 'active', '2023-01-01', NULL, CURRENT_TIMESTAMP);

INSERT INTO pacotes_dados (id_linha, descricao, franquia_gb, status, data_inicio, data_fim)
VALUES (1, 'Pacote de Dados Internacional', 5.00, 'active', '2023-01-01', NULL);

INSERT INTO servicos_adicionais (id_linha, descricao, valor_mensal, status, data_inicio, data_fim)
VALUES (1, 'Seguro Celular', 15.90, 'active', '2023-01-01', NULL);

INSERT INTO faturas (id_linha, mes_referencia, valor_fatura, status_fatura, data_criacao)
VALUES (1, '2023-07', 150.00, 'paid', CURRENT_TIMESTAMP),
       (1, '2023-08', 150.00, 'unpaid', CURRENT_TIMESTAMP);

INSERT INTO pagamentos (id_fatura, data_pagamento, valor_pago, status_pagamento)
VALUES (1, '2023-07-15', 150.00, 'successful');

-- Cliente 2
INSERT INTO clientes (nome, cpf, email, telefone, data_criacao)
VALUES ('Cliente Y', '98765432100', 'clientey@exemplo.com', '+5511998765432', CURRENT_TIMESTAMP);

INSERT INTO linhas_moveis (id_cliente, numero_linha, plano, status, data_inicio, data_fim, data_criacao)
VALUES (2, '+5511998765432', 'Vivo Pós 50GB', 'active', '2023-06-01', NULL, CURRENT_TIMESTAMP);

INSERT INTO pacotes_dados (id_linha, descricao, franquia_gb, status, data_inicio, data_fim)
VALUES (2, 'Pacote de Dados Roaming', 10.00, 'active', '2023-06-01', NULL);

INSERT INTO servicos_adicionais (id_linha, descricao, valor_mensal, status, data_inicio, data_fim)
VALUES (2, 'Roaming Internacional', 49.90, 'active', '2023-06-01', NULL);

INSERT INTO faturas (id_linha, mes_referencia, valor_fatura, status_fatura, data_criacao)
VALUES (2, '2023-07', 250.00, 'paid', CURRENT_TIMESTAMP),
       (2, '2023-08', 250.00, 'unpaid', CURRENT_TIMESTAMP);

INSERT INTO pagamentos (id_fatura, data_pagamento, valor_pago, status_pagamento)
VALUES (3, '2023-07-20', 250.00, 'successful');
