# Policy Manager

Sistema simples para gerenciamento de apólices de seguro, desenvolvido em Ruby on Rails, com controle de acesso baseado em papéis para garantir permissões específicas:

- **Admin:** acesso completo — pode criar, visualizar, editar e excluir qualquer apólice.
- **Operador:** pode visualizar todas as apólices e criar novas.
- **Cliente:** pode apenas visualizar somente suas próprias apólices.

## Tecnologias Utilizadas

- Ruby 3.2.1
- Rails 7.1.5
- PostgreSQL

## Funcionalidades

- Controle de acesso via políticas Pundit aplicadas nas controllers.
- API JSON-only para todas as requisições.
- Testes automatizados com cobertura para diferentes papéis e ações.

## Como Rodar

1. Clone o repositório:

   ```bash
   git clone https://github.com/seuusuario/policy_manager.git
   cd policy_manager
   
2. Crie um arquivo .env na pasta raiz do projeto com os seguintes dados:

   ```bash
   POSTGRES_USER=
   POSTGRES_PASSWORD=
   POSTGRES_HOST=
   POSTGRES_PORT=
   DEVELOP_DATABASE_URL=
   TEST_DATABASE_URL=
   PROD_DATABASE_URL=

3. Instale as dependências:
   ```bash
   bundle install
   
4. Popule o banco de dados:

   ```bash
   rails db:create db:migrate db:seed

5. Rode os testes automatizados:

   ```bash
   bundle exec rspec

## Testes via Postman

### 1. Autenticar e obter token JWT

```http
POST http://localhost:3000/users/sign_in
```

**Headers:**

```http
Content-Type: application/json
```

**Body (JSON):**

```json
{
  "user": {
    "email": "admin@email.com",
    "password": "senha123"
  }
}
```

**Response:**

```json
{
  "message": "Login successful",
  "user": {
    "id": 1,
    "email": "admin@email.com"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

⚠️ Copie o valor do campo `"token"` para usar nas demais requests.


### 2. Testar endpoints da API de Apólices

#### Headers obrigatórios:

```http
Content-Type: application/json
Authorization: Bearer SEU_TOKEN_AQUI
```

#### 🔵  Listar Apólices

```http
GET http://localhost:3000/insurance_policies
```

#### 🔵  Visualizar uma Apólice

```http
GET http://localhost:3000/insurance_policies/:id
```

#### 🔵  Criar Apólice

```http
POST http://localhost:3000/insurance_policies
```

**Body (JSON):**

```json
{
  "insurance_policy": {
    "policy_number": "121212121212",
    "start_date": "2025-08-01",
    "end_date": "2025-12-31",
    "total_deductible": 5000.0,
    "total_coverage": 100000.0,
    "status": "active"
    "user_id": 1
  }
}
```

#### 🔵  Atualizar Apólice

```http
PATCH http://localhost:3000/insurance_policies/1
```

**Body (JSON):**

```json
{
  "insurance_policy": {
    "status": "canceled"
  }
}
```

#### 🔵  Excluir Apólice

```http
DELETE http://localhost:3000/insurance_policies/1
```


