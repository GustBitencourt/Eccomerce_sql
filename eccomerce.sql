-- cria database
CREATE DATABASE ecommerce;
-- utiliza database
USE ecommerce;

-- Tabela Cliente
CREATE TABLE clientes(
	idCliente INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(30),
    lastName VARCHAR(30),
    CPF CHAR(11) NOT NULL,
    endereco VARCHAR(200),
    CONSTRAINT unique_cpf_client UNIQUE(CPF)
);

-- Tbale produto
CREATE TABLE produto(
	idProduto INT AUTO_INCREMENT PRIMARY KEY,
	prodName VARCHAR(255) NOT NULL,
	classification_kids BOOL DEFAULT FALSE,
	categoria ENUM('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') NOT NULL,
	avaliacao FLOAT DEFAULT 0,
	tamanho VARCHAR(10)
);

-- Tabela pagamento
CREATE TABLE pagamentos(
	idCliente INT,
    idPagamento INT,
    typePayment ENUM('Boleto','Cartão','Dois cartões'),
    limitAvailable FLOAT,
    PRIMARY KEY(idCliente, idPagamento)
);

-- Tabela pedidos
CREATE TABLE pedidos(
	idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    statusPedido ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    descricaoPedido VARCHAR(255),
    frete FLOAT DEFAULT 10,
    pagamentoDinheiro BOOLEAN DEFAULT FALSE, 
    CONSTRAINT fk_ordes_client FOREIGN KEY (idCliente) 
    REFERENCES clientes(idCliente) ON UPDATE CASCADE
);

-- criar tabela estoque
CREATE TABLE estoque(
	idProdEstoque INT AUTO_INCREMENT PRIMARY KEY,
    localizacao VARCHAR(255),
    quantidade INT DEFAULT 0
);

-- criar tabela fornecedor
CREATE TABLE fornecedor(
	idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_fornecedor UNIQUE (CNPJ)
);

-- criar tabela vendedor
CREATE TABLE vendedor(
	idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(9),
    location VARCHAR(255),
    contato CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_vendedor UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_vendedor UNIQUE (CPF)
);

-- tabela de relacionamento M:N
CREATE TABLE produtoVendedor(
	idVendedor INT,
    idProduto INT,
    prodQuantidade INT DEFAULT 1,
    PRIMARY KEY (idVendedor, idProduto),
    CONSTRAINT fk_produto_vendedor FOREIGN KEY (idVendedor) REFERENCES vendedor(idVendedor),
    CONSTRAINT fk_produto_produto FOREIGN KEY (idProduto) REFERENCES produto(idProduto)
);

CREATE TABLE produtoPedido(
	idProduto INT,
    idPedido INT,
    prodPedQuantidade INT DEFAULT 1,
    prodStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idProduto, idPedido),
    CONSTRAINT Fk_produtoPedido_produto FOREIGN KEY (idProduto) REFERENCES produto(idProduto),
    CONSTRAINT Fk_produtoPedido_order FOREIGN KEY (idPedido) REFERENCES pedidos(idPedido)
);

CREATE TABLE localEstoque(
	idProduto INT,
    idProdEstoque INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idProduto, idProdEstoque),
    CONSTRAINT fk_storage_location_produto FOREIGN KEY (idProduto) REFERENCES produto(idProduto),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idProdEstoque) REFERENCES estoque(idProdEstoque)
);

CREATE TABLE fornecedorProduto(
	idFornecedor INT,
    idProduto INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (idFornecedor, idProduto),
    CONSTRAINT fk_produto_fornecedor_fornecedor FOREIGN KEY (idFornecedor) REFERENCES fornecedor(idFornecedor),
    CONSTRAINT fk_produto_fornecedor_prodcut FOREIGN KEY (idProduto) REFERENCES produto(idProduto)
);

-- MOSTRA OS DETALHES DA TABELA
DESC fornecedorProduto;

-- MOSTRA OS DATABASES
SHOW DATABASES;

-- Verificar as constraints do banco
USE information_schema;

-- MOSTRA AS TABELAS
SHOW TABLES;

-- mostra descricao de referential constraints
DESC referential_constraints;

-- desrição das constraints do bd ecommerce 
SELECT * FROM referential_constraints WHERE constraint_schema = 'ecommerce';


-- inserção de dados e queries
SHOW TABLES;

-- idCliente, firstName, Minit, Lname, CPF, Address
INSERT INTO clientes (firstName, lastName, CPF, endereco) 
	VALUES
		('Maria', 'Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
		('Matheus', 'Pimentel', 987654321,'rua alemeda 289, Centro - Cidade das flores'),
		('Ricardo', 'Silva', 45678913,'avenida alemeda vinha 1009, Centro - Cidade das flores'),
		('Julia', 'França', 789123456,'rua lareijras 861, Centro - Cidade das flores'),
		('Roberta', 'Assis', 98745631,'avenidade koller 19, Centro - Cidade das flores'),
		('Isabela', 'Cruz', 654789123,'rua alemeda das flores 28, Centro - Cidade das flores');


-- idproduto, Pname, classification_kids boolean, categoria('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliacao, tamanho
INSERT INTO produto (prodName, classification_kids, categoria, avaliacao, tamanho) 
	VALUES
		('Fone de ouvido',false,'Eletrônico','4',null),
		('Barbie Elsa',true,'Brinquedos','3',null),
		('Body Carters',true,'Vestimenta','5',null),
		('Microfone Vedo - Youtuber',False,'Eletrônico','4',null),
		('Sofá retrátil',False,'Móveis','3','3x57x80'),
		('Farinha de arroz',False,'Alimentos','2',null),
		('Fire Stick Amazon',False,'Eletrônico','3',null);

SELECT * FROM clientes;
SELECT * FROM produto;
-- idPedido, idCliente, statusPedido, descricaoPedido, frete, pagamentoDinheiro

-- delete de pedidos
DELETE FROM pedidos WHERE idCliente IN  (1,2,3,4);

INSERT INTO pedidos (idCliente, statusPedido, descricaoPedido, frete, pagamentoDinheiro) 
	VALUES 
		(1, DEFAULT,'compra via aplicativo',NULL,1),
		(2,DEFAULT,'compra via aplicativo',50,0),
		(3,'Confirmado',NULL,NULL,1),
		(4,DEFAULT,'compra via web site',150,0);

-- idProduto, idPedido, prodPedquantidade, prodStatus
SELECT * FROM pedidos;

desc produtoPedido;
INSERT INTO produtoPedido (idProduto, idPedido, prodPedQuantity, prodStatus) 
	VALUES
		(1,5,2,NULL),
		(2,5,1,NULL),
		(3,6,1,NULL);

-- localEstoque,quantidade
INSERT INTO estoque (localizacao,quantidade) 
	VALUES 
		('Rio de Janeiro',1000),
		('Rio de Janeiro',500),
		('São Paulo',10),
		('São Paulo',100),
		('São Paulo',10),
		('BRasília',60);

-- idProduto, idProdEstoque, location
INSERT INTO localEstoque (idProduto, idProdEstoque, location) 
	VALUES
		(1,2,'RJ'),
		(2,6,'GO');

-- idfornecedor, SocialName, CNPJ, contact
INSERT INTO fornecedor (SocialName, CNPJ, contact) 
	VALUES 
		('Almeida e filhos', 123456789123456,'21985474'),
		('Eletrônicos Silva',854519649143457,'21985484'),
		('Eletrônicos Valma', 934567893934695,'21975474');
                            
SELECT * FROM fornecedor;
-- idProduto, idProdEstoque, quantidade

desc fornecedorProduto;
INSERT INTO fornecedorProduto (idFornecedor, idProduto, quantidade) 
	VALUES
		(1,1,500),
		(1,2,400),
		(2,4,633),
		(3,3,5),
		(2,5,10);

-- idvendedor, SocialName, AbstName, CNPJ, CPF, location, contact
desc vendedor;
INSERT INTO vendedor (SocialName, AbstName, CNPJ, CPF, location, contato) 
	VALUES 
		('Tech eletronics', NULL, 123456789456321, NULL, 'Rio de Janeiro', 219946287),
		('Botique Durgas',NULL,NULL,123456783,'Rio de Janeiro', 219567895),
		('Kids World',NULL,456789123654485,NULL,'São Paulo', 1198657484);

SELECT * FROM vendedor;
-- idVendedor, idProduto, prodQuantidade
INSERT INTO produtoVendedor (idVendedor, idProduto, prodQuantidade) 
	VALUES 
		(1,6,80),
		(2,7,10);

SELECT * FROM produtoVendedor;

SELECT COUNT(*) FROM clientes;

SELECT * 
FROM clientes c, pedidos o 
WHERE c.idCliente = o.idCliente;

SELECT firstName,lastName, idPedido, statusPedido 
FROM clientes c, pedidos o 
WHERE c.idCliente = o.idCliente;

SELECT CONCAT(firstName,' ',lastName) AS Client, idPedido AS Request, statusPedido AS Status 
FROM clientes c, pedidos o 
WHERE c.idCliente = o.idCliente;

INSERT INTO pedidos (idCliente, statusPedido, descricaoPedido, frete, pagamentoDinheiro) 
	VALUES 
		(2, DEFAULT,'compra via aplicativo',NULL,1);
                             
SELECT COUNT(*) 
FROM clientes c, pedidos o 
WHERE c.idCliente = o.idCliente;

SELECT * FROM produtoPedido;

-- recuperação de pedido com produto associado
SELECT *
FROM clientes c 
INNER JOIN pedidos p
ON c.idCliente = p.idCliente
GROUP BY c.idCliente;

-- Recuperar quantos pedidos foram realizados pelos clientes?
SELECT c.idCliente, firstName, COUNT(*) AS Number_of_pedidos 
FROM clientes c 
INNER JOIN pedidos o 
ON c.idCliente = o.idCliente
GROUP BY idCliente;

